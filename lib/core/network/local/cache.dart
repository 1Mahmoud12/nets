import 'package:hive_flutter/adapters.dart';
import 'package:nets/feature/auth/data/models/login_model.dart';

Box? userCache;
Box? loginCache;
Box? dataCache;
String userCacheBoxKey = 'userCache';
String dataCacheBoxKey = 'dataCache';
String loginCacheBoxKey = 'loginCache';
// keys

String languageAppKey = 'languageAppKey';
String lastArticlesKey = 'lastArticlesKey';
String onBoardingKey = 'onBoardingKey';
String userCacheKey = 'userCacheKey';
String darkModeKey = 'darkModeKey';
String checkedNotificationKey = 'checkedNotificationKey';
String closeUrgentNewKey = 'closeUrgentNewKey';
String themeModeKey = 'themeModeKey';
String splashHomeModelKey = 'splashHomeModelKey';
String locationCacheKey = 'locationCacheKey';
String favoritesKey = 'favoritesKey';
String favoriteArticleDetailsKey = 'favoriteArticleDetailsKey';
String allMyAddressesKey = 'allMyAddressesKey';
String advertiseModelKey = 'advertiseModelKey';
String categoriesModelKey = 'categoriesModelKey';
int idUserValue = 0;
String fcmTokenKey = 'fcmTokenKey';
String deviceIdKey = 'deviceIdKey';
String dynamicArticleKey = 'dynamicArticleKey';
String customLastArticleByDepartmentIdModel = 'customLastArticleByDepartmentIdModel';
String articlesForYouKey = 'articlesForYouKey';
String storiesModelKey = 'storiesModelKey';

// biometrics
String biometricEnabledKey = 'biometricEnabledKey';
String biometricTypeKey = 'biometricTypeKey';
String biometricUserCacheKey = 'biometricUserCacheKey';
String biometricAuthKey = 'biometricAuthKey';

// login credentials
String loginEmailKey = 'loginEmailKey';
String loginPasswordKey = 'loginPasswordKey';

// value
bool onBoardingValue = true;
bool rememberMe = false;

bool darkModeValue = false;
bool checkedNotification = false;
bool closeUrgentNewValue = false;
String themeModeValue = 'light'; // 'light', 'dark', 'auto'

LoginModel? userCacheValue;

String? locationCacheValue;
