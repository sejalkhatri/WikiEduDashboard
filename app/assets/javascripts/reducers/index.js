import { combineReducers } from 'redux';
import alerts from './alerts';
import articleDetails from './article_details';
import articleFinder from './article_finder';
import articles from './articles';
import assignments from './assignments';
import campaigns from './campaigns';
import categories from './categories';
import chat from './chat';
import confirm from './confirm';
import course from './course';
import courseCreator from './course_creator';
import didYouKnow from './did_you_know';
import feedback from './feedback';
import needHelpAlert from './need_help_alert';
import newAccount from './new_account';
import notifications from './notifications';
import persistedCourse from './persisted_course';
import recentEdits from './recent_edits.js';
import recentUploads from './recent_uploads';
import revisions from './revisions';
import suspectedPlagiarism from './suspected_plagiarism';
import settings from './settings';
import tags from './tags';
import timeline from './timeline';
import training from './training';
import trainingStatus from './training_status';
import userTrainingStatus from './user_training_status';
import ui from './ui';
import uploads from './uploads';
import userCourses from './user_courses';
import userProfile from './user_profile';
import userRevisions from './user_revisions';
import users from './users';
import wikidataLabels from './wikidata_labels';
import wizard from './wizard';

const reducer = combineReducers({
  alerts,
  articleDetails,
  articleFinder,
  articles,
  assignments,
  campaigns,
  categories,
  chat,
  confirm,
  course,
  courseCreator,
  currentUserFromHtml: (state = {}) => state, // only set from preloaded state
  didYouKnow,
  feedback,
  needHelpAlert,
  newAccount,
  notifications,
  persistedCourse,
  recentEdits,
  recentUploads,
  revisions,
  suspectedPlagiarism,
  settings,
  tags,
  timeline,
  training,
  trainingStatus,
  ui,
  uploads,
  userCourses,
  userProfile,
  userRevisions,
  userTrainingStatus,
  users,
  wikidataLabels,
  wizard
});

export default reducer;
