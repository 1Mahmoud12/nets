part of 'qr_cubit.dart';

@immutable
sealed class QrState {}

final class QrInitial extends QrState {}
final class QrLoading extends QrState {}
final class QrSuccess extends QrState {}
final class QrError extends QrState {
  QrError(this.error);
  final String error;
}
