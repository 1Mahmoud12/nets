part of 'phone_number_sharing_cubit.dart';

@immutable
sealed class PhoneNumberSharingState {}

final class PhoneNumberSharingInitial extends PhoneNumberSharingState {}

final class PhoneNumberSharingLoading extends PhoneNumberSharingState {}

final class PhoneNumberSharingSuccess extends PhoneNumberSharingState {}

final class PhoneNumberSharingError extends PhoneNumberSharingState {
  PhoneNumberSharingError(this.message);
  final String message;
}


