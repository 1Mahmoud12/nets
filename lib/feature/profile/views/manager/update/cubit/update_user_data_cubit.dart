import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:nets/core/utils/utils.dart';
import 'package:nets/feature/profile/data/dataSource/user_data_source.dart';
import 'package:nets/feature/profile/data/models/user_data_param.dart';

part 'update_user_data_state.dart';

class UpdateUserDataCubit extends Cubit<UpdateUserDataState> {
  UpdateUserDataCubit() : super(UpdateUserDataInitial());
  Future<void> updateUserData(UserDataParam userData) async {
    emit(UpdateUserDataLoading());
    await UserDataSource.updateUserData(userData).then((value) {
      value.fold(
        (l) {
          emit(UpdateUserDataError(error: l.errMessage));
        },
        (r) {
          emit(UpdateUserDataSuccess());
          //show toast success
          Utils.showToast(title: 'update_user_data_success'.tr(), state: UtilState.success);
        },
      );
    });
  }

  Future<void> updateUserImage(File image) async {
    emit(UpdateUserDataImageLoading());
    await UserDataSource.updateUserImage({
      'image': await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      '_method': 'put',
    }).then((value) {
      value.fold(
        (l) {
          emit(UpdateUserDataImageError(error: l.errMessage));
        },
        (r) {
          Utils.showToast(title: 'update_user_image_success'.tr(), state: UtilState.success);
          emit(UpdateUserDataImageSuccess());
        },
      );
    });
  }
}
