part of 'splash_home_cubit.dart';

@immutable
sealed class SplashHomeState {}

final class SplashHomeInitial extends SplashHomeState {}

final class SplashHomeLoading extends SplashHomeState {}

final class SplashHomeSuccess extends SplashHomeState {}

final class SplashHomeError extends SplashHomeState {
  final String e;

  SplashHomeError({required this.e});
}
