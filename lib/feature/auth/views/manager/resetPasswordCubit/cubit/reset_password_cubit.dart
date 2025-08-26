import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/core/utils/errorLoadingWidgets/dialog_loading_animation.dart';
import 'package:nets/core/utils/navigate.dart';
import 'package:nets/feature/auth/views/presentation/successfullty_view.dart';

import '../../../../data/dataSource/reset_password_data_source.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  static ResetPasswordCubit of(BuildContext context) => BlocProvider.of<ResetPasswordCubit>(context);

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr();
    }
    if (value.length < 8) {
      return 'password_length'.tr();
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != newPasswordController.text) {
      return 'passwords_do_not_match'.tr();
    }
    return null;
  }

  ResetPasswordDataSourceInterface resetPasswordDataSource = ResetPasswordDataSourceImplementation();

  Future<void> resetPassword({required BuildContext context, bool homeView = true, String? tempToken}) async {
    emit(ResetPasswordLoading());
    animationDialogLoading(context);
    final result = await resetPasswordDataSource.resetPassword(
      data: {
        'password': newPasswordController.text,
        'auth_key': tempToken ?? Constants.token,
        'password_confirmation': confirmPasswordController.text,
      },
    );
    if (context.mounted) closeDialog(context);
    result.fold(
      (l) {
        emit(ResetPasswordError(l.errMessage));
        //  customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
      },
      (r) {
        emit(ResetPasswordSuccess());
        if (context.mounted) {
          context.navigateToPage(SuccessfullyView(homeView: homeView));
        }
        customShowToast(context, r);
      },
    );
  }

  @override
  Future<void> close() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
