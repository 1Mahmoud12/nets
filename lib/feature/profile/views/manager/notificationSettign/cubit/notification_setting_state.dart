part of 'notification_setting_cubit.dart';

@immutable
sealed class NotificationSettingState {}

final class NotificationSettingInitial extends NotificationSettingState {}

final class NotificationSettingLoading extends NotificationSettingState {}

final class NotificationSettingSuccess extends NotificationSettingState {}

final class NotificationSettingError extends NotificationSettingState {
  NotificationSettingError(this.message);

  final String message;
}
