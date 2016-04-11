# == Schema Information
#
# Table name: courses_users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  course_id              :integer
#  user_id                :integer
#  character_sum_ms       :integer          default(0)
#  character_sum_us       :integer          default(0)
#  revision_count         :integer          default(0)
#  assigned_article_title :string(255)
#  role                   :integer          default(0)
#

require "#{Rails.root}/lib/utils"

#= Course + User join model
class CoursesUsers < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  before_destroy :cleanup

  has_many :assignments, -> (ac) { where(course_id: ac.course_id) },
           through: :user

  has_many :survey_notifications

  validates :course_id, uniqueness: { scope: [:user_id, :role] }

  scope :current, -> { joins(:course).merge(Course.current).uniq }

  ####################
  # CONSTANTS        #
  ####################

  module Roles
    VISITOR_ROLE          = -1
    STUDENT_ROLE          = 0
    INSTRUCTOR_ROLE       = 1
    CAMPUS_VOLUNTEER_ROLE = 2
    ONLINE_VOLUNTEER_ROLE = 3
    WIKI_ED_STAFF_ROLE    = 4
  end

  ####################
  # Instance methods #
  ####################
  def character_sum_ms
    update_cache unless self[:character_sum_ms]
    self[:character_sum_ms]
  end

  def character_sum_us
    update_cache unless self[:character_sum_us]
    self[:character_sum_us]
  end

  def revision_count
    update_cache unless self[:revision_count]
    self[:revision_count]
  end

  def assigned_article_title
    update_cache unless self[:assigned_article_title]
    self[:assigned_article_title]
  end

  def update_cache
    revisions = course.revisions.joins(:article)
                .where(user_id: user.id)
    self.character_sum_ms = character_sum(revisions, Article::Namespaces::MAINSPACE)
    self.character_sum_us = character_sum(revisions, Article::Namespaces::USER)
    self.revision_count = revisions
      .where(articles: { deleted: false })
      .size || 0
    assignments = user.assignments.where(course_id: course.id)
    self.assigned_article_title = assignments.empty? ? '' : assignments.first.article_title
    save
  end

  ##################
  # Helper methods #
  ##################
  def character_sum(revisions, namespace)
    revisions
      .where(articles: { namespace: namespace, deleted: false })
      .where('characters >= 0')
      .sum(:characters) || 0
  end

  def cleanup
    Assignment.where(user_id: user_id, course_id: course_id).destroy_all
  end

  #################
  # Class methods #
  #################
  def self.update_all_caches(courses_users=nil)
    Utils.run_on_all(CoursesUsers, :update_cache, courses_users)
  end
end
