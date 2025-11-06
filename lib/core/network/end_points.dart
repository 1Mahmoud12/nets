class EndPoints {
  static const domain = 'https://nets.web-demo.website';

  //static const domain = 'https://almamlka01jo2025.dev2.dot.jo';
  static const baseUrl = '$domain/api/';

  // Auth
  static const countryCodes = 'Account/CountryCodes';
  static const register = 'general/register';
  static const login = 'auth/send-otp';
  static const updateDeviceToken = 'update-device-info';
  static const validateOTP = 'Account/ValidateOTP';
  static const updateFcmToken = 'Account/UpdateFCMToken';
  static const staticPages = 'basic-page';
  static const resetPassword = 'update-password';
  static const otp = 'otp';
  static const verifyOtp = 'auth/verify-otp';
  static const updateProfile = 'update-profile';
  static const deactivateAccount = 'deactivate-account';
  static const userData = 'profile';
  static const notificationSettings = 'profile/notification-settings';
  static const userStatistics = 'profile/general-information';
  static const deleteUser = 'Account/DeleteUser';

  //home page
  static const generalEndpoint = 'resources';
  static const checkLink = 'deeplink/check-device';
  static const splashAndHomePage = 'look-up';
  static const stories = 'vod';
  static const dynamicArticles = 'dynamic-articles';
  static const allFavorites = 'get-bookmarked-articles';
  static const bookmarkToggle = 'article-bookmark-toggle';
  static const weather = 'weather';
  static const toggleCategoryFavorite = 'category-favorite-toggle';
  static const articleDetails = 'get-article';
  static const departmentsSubCategories = 'departments-with-sub-categories';

  // notifications
  static const notifications = 'notifications';
  static const readNotification = 'mark-as-read';
  static const unreadCountNotification = 'unread-count';
}
