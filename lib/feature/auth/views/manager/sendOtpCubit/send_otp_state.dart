part of 'send_otp_cubit.dart';

@immutable
sealed class SendOtpState {}

final class SendOtpInitial extends SendOtpState {}

final class SendOtpLoading extends SendOtpState {}

final class SendOtpSuccess extends SendOtpState {}

final class SendOtpError extends SendOtpState {
  final String e;

  SendOtpError({required this.e});
}
