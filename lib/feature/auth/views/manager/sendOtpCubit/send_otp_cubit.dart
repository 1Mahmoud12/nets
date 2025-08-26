import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nets/core/utils/custom_show_toast.dart';
import 'package:nets/feature/auth/data/dataSource/register_data_source.dart';

part 'send_otp_state.dart';

class SendOtpCubit extends Cubit<SendOtpState> {
  SendOtpCubit() : super(SendOtpInitial());

  static SendOtpCubit of(BuildContext context) => BlocProvider.of<SendOtpCubit>(context);

  Future<void> sendOtp({required BuildContext context, required String email}) async {
    emit(SendOtpLoading());

    await RegisterDataSource.sendOtp(email: email).then((value) {
      value.fold(
        (l) {
          emit(SendOtpError(e: l.errMessage));
          customShowToast(context, l.errMessage, showToastStatus: ShowToastStatus.error);
        },
        (r) async {
          // if (email == 'mahmoudm@gmail.com') {
          //   customShowToast(context, r.toString(), showToastStatus: ShowToastStatus.success, showToastPosition: ShowToastPosition.top);
          // }

          emit(SendOtpSuccess());
        },
      );
    });
  }
}
