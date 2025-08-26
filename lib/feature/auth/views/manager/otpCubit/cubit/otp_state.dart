part of 'otp_cubit.dart';

abstract class OTPState {}

class OTPInitial extends OTPState {}

class OTPLoading extends OTPState {}

class OTPSuccess extends OTPState {}

class OTPError extends OTPState {
  final String e;

  OTPError({required this.e});
}

class OTPVerified extends OTPState {}

class OTPTimerRunning extends OTPState {
  final String timerText;
  OTPTimerRunning(this.timerText);
}

class OTPExpired extends OTPState {}
