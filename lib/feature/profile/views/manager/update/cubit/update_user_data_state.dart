part of 'update_user_data_cubit.dart';

@immutable
sealed class UpdateUserDataState {}

final class UpdateUserDataInitial extends UpdateUserDataState {}

final class UpdateUserDataImageLoading extends UpdateUserDataState {}

final class UpdateUserDataImageSuccess extends UpdateUserDataState {}

final class UpdateUserDataImageError extends UpdateUserDataState {
  final String error;

  UpdateUserDataImageError({required this.error});
}

final class UpdateUserDataLoading extends UpdateUserDataState {}

final class UpdateUserDataSuccess extends UpdateUserDataState {}

final class UpdateUserDataError extends UpdateUserDataState {
  final String error;

  UpdateUserDataError({required this.error});
}
