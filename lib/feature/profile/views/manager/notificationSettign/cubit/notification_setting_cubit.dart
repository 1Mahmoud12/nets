import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/auth/data/models/login_model.dart' as login;
import 'package:nets/feature/profile/data/models/user_data_model.dart' as user_data;
import 'package:nets/feature/profile/data/dataSource/user_data_source.dart';

part 'notification_setting_state.dart';

class NotificationSettingCubit extends Cubit<NotificationSettingState> {
  NotificationSettingCubit() : super(NotificationSettingInitial());

  Future<void> updateNotificationSettings({required bool pushNotification, required bool emailNotification, required bool smsNotification}) async {
    emit(NotificationSettingLoading());
    final result = await UserDataSource.updateUserDataNotificationSettings(pushNotification, emailNotification, smsNotification);
    result.fold((failure) => emit(NotificationSettingError(failure.errMessage)), (_) {
      final userData = ConstantsModels.userDataModel?.data;
      if (userData != null) {
        userData.notificationSettings ??= user_data.NotificationSettings();
        userData.notificationSettings!
          ..pushNotification = pushNotification
          ..emailNotification = emailNotification
          ..smsNotification = smsNotification;
      }

      if (userCacheValue?.data?.user != null) {
        final user = userCacheValue!.data!.user!;
        user.notificationSettings ??= login.NotificationSettings();
        user.notificationSettings!
          ..pushNotification = pushNotification
          ..emailNotification = emailNotification
          ..smsNotification = smsNotification;

        userCache?.put(userCacheKey, jsonEncode(userCacheValue!.toJson()));
      }

      emit(NotificationSettingSuccess());
    });
  }
}
