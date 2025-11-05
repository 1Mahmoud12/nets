import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/auth/data/models/login_model.dart' as login;
import 'package:nets/feature/profile/data/dataSource/user_data_source.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitial());
  Future<void> getUserData() async {
    emit(UserDataLoading());
    await UserDataSource.getUserData().then((value) {
      value.fold(
        (l) {
          emit(UserDataError(error: l.errMessage));
        },
        (r) {
          ConstantsModels.userDataModel = r;
          // Update userCacheValue with new profile data
          _updateUserCache(r);
          emit(UserDataSuccess());
        },
      );
    });
  }

  void _updateUserCache(profileData) {
    if (userCacheValue != null && userCacheValue!.data != null && userCacheValue!.data!.user != null) {
      final userData = profileData.data;
      if (userData != null) {
        // Update the profile in userCacheValue
        if (userData.profile != null) {
          // Create or update profile
          if (userCacheValue!.data!.user!.profile == null) {
            userCacheValue!.data!.user!.profile = login.Profile();
          }
          // Update profile fields
          userCacheValue!.data!.user!.profile!.firstName = userData.profile!.firstName;
          userCacheValue!.data!.user!.profile!.lastName = userData.profile!.lastName;
          userCacheValue!.data!.user!.profile!.email = userData.profile!.email;
          userCacheValue!.data!.user!.profile!.image = userData.profile!.image;
          userCacheValue!.data!.user!.profile!.website = userData.profile!.website;
          userCacheValue!.data!.user!.profile!.zipCode = userData.profile!.zipCode;
          userCacheValue!.data!.user!.profile!.streetName = userData.profile!.streetName;
          userCacheValue!.data!.user!.profile!.buildingNumber = userData.profile!.buildingNumber;
          userCacheValue!.data!.user!.profile!.streetNumber = userData.profile!.streetNumber;
          userCacheValue!.data!.user!.profile!.additionalInformation = userData.profile!.additionalInformation;
          userCacheValue!.data!.user!.profile!.titleWork = userData.profile!.titleWork;
          userCacheValue!.data!.user!.profile!.id = userData.profile!.id;
          userCacheValue!.data!.user!.profile!.userId = userData.profile!.userId;
          userCacheValue!.data!.user!.profile!.qrCodeData = userData.profile!.qrCodeData;
          userCacheValue!.data!.user!.profile!.createdAt = userData.profile!.createdAt;
          userCacheValue!.data!.user!.profile!.updatedAt = userData.profile!.updatedAt;
        }
        // Update other user fields
        userCacheValue!.data!.user!.phone = userData.phone;
        userCacheValue!.data!.user!.sharePhoneNumber = userData.sharePhoneNumber;
        userCacheValue!.data!.user!.notifyMe = userData.notifyMe;
        userCacheValue!.data!.user!.allUserAutoAsync = userData.allUserAutoAsync;
        // Update notification settings - copy fields instead of assigning object
        if (userData.notificationSettings != null) {
          if (userCacheValue!.data!.user!.notificationSettings == null) {
            userCacheValue!.data!.user!.notificationSettings = login.NotificationSettings();
          }
          userCacheValue!.data!.user!.notificationSettings!.id = userData.notificationSettings!.id;
          userCacheValue!.data!.user!.notificationSettings!.userId = userData.notificationSettings!.userId;
          userCacheValue!.data!.user!.notificationSettings!.pushNotification = userData.notificationSettings!.pushNotification;
          userCacheValue!.data!.user!.notificationSettings!.smsNotification = userData.notificationSettings!.smsNotification;
          userCacheValue!.data!.user!.notificationSettings!.emailNotification = userData.notificationSettings!.emailNotification;
          userCacheValue!.data!.user!.notificationSettings!.createdAt = userData.notificationSettings!.createdAt;
          userCacheValue!.data!.user!.notificationSettings!.updatedAt = userData.notificationSettings!.updatedAt;
        }
      }
      // Save to cache
      userCache?.put(userCacheKey, jsonEncode(userCacheValue!.toJson()));
      ConstantsModels.loginModel = userCacheValue;
    }
  }
}
