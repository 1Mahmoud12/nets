part of 'my_journey_cubit.dart';

@immutable
sealed class MyJourneyState {}

final class MyJourneyInitial extends MyJourneyState {}

final class MyJourneyLoading extends MyJourneyState {}

final class MyJourneySuccess extends MyJourneyState {
  MyJourneySuccess(this.journeys);
  final JourneyModel journeys;
}

final class MyJourneyError extends MyJourneyState {
  MyJourneyError(this.message);
  final String message;
}


