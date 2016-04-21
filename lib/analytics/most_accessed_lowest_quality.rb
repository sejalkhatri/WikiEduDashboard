class MostAccessedLowestQuality
  def initialize(opts={})
    @ratings = opts[:ratings] || %w(stub start)
    @average_views_min = opts[:average_views_min] || 250
    @cohorts = opts[:cohorts] || Cohort.where(slug: %w(summer_2015 fall_2015 spring_2016))
  end

  def all_articles
    @all_articles ||= courses.collect(&:articles).flatten.uniq
    @all_articles
  end

  def coursesall
    @courses ||= @cohorts.collect(&:courses).flatten.uniq
    @courses
  end

  def malq_articles
    all_articles.select do |article|
      next false unless @ratings.include?(article.rating)
      next false if articles.average_views.nil?
      article.average_views > @average_views_min
    end
  end
end
