part of 'get_user_statistics_cubit.dart';

@immutable
sealed class GetUserStatisticsState {}

final class GetUserStatisticsInitial extends GetUserStatisticsState {}

final class GetUserStatisticsLoading extends GetUserStatisticsState {}

final class GetUserStatisticsSuccess extends GetUserStatisticsState {
  final UserStatisticsModel statistics;

  GetUserStatisticsSuccess(this.statistics);
}

final class GetUserStatisticsError extends GetUserStatisticsState {
  final String message;

  GetUserStatisticsError(this.message);
}
