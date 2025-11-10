import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/profile/data/dataSource/user_data_source.dart';

part 'phone_number_sharing_state.dart';

class PhoneNumberSharingCubit extends Cubit<PhoneNumberSharingState> {
  PhoneNumberSharingCubit() : super(PhoneNumberSharingInitial());

  Future<void> updatePhoneNumberSharing({
    required bool sharePhoneNumber,
    required bool notifyMe,
    required bool allUserAutoAsync,
  }) async {
    emit(PhoneNumberSharingLoading());
    final result = await UserDataSource.updatePhoneNumberSharingSettings(
      sharePhoneNumber: sharePhoneNumber,
      notifyMe: notifyMe,
      allUserAutoAsync: allUserAutoAsync,
    );
    result.fold(
      (failure) => emit(PhoneNumberSharingError(failure.errMessage)),
      (_) {
        final userData = ConstantsModels.userDataModel?.data;
        if (userData != null) {
          userData.sharePhoneNumber = sharePhoneNumber;
          userData.notifyMe = notifyMe;
          userData.allUserAutoAsync = allUserAutoAsync;
        }

        if (userCacheValue?.data?.user != null) {
          final user = userCacheValue!.data!.user!;
          user.sharePhoneNumber = sharePhoneNumber;
          user.notifyMe = notifyMe;
          user.allUserAutoAsync = allUserAutoAsync;
          userCache?.put(userCacheKey, jsonEncode(userCacheValue!.toJson()));
        }

        emit(PhoneNumberSharingSuccess());
      },
    );
  }
}


