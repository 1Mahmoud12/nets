abstract class MainState {}

class MainInitial extends MainState {}

class ChangeInitialState extends MainState {}

class HomeChangeState extends MainState {}

class ChangeThemeState extends MainState {}

class HomeGetAllBranchesLoadingState extends MainState {}

class HomeGetAllBranchesSuccessState extends MainState {}

class HomeGetAllBranchesErrorState extends MainState {
  final String error;

  HomeGetAllBranchesErrorState(this.error);
}

class AddFavoriteState extends MainState {}

class RemoveFavoriteState extends MainState {}

class GetHomeNotificationLoadingState extends MainState {}

class GetHomeNotificationSuccessState extends MainState {}

class BookMarkErrorState extends MainState {
  String error;

  BookMarkErrorState(this.error);
}

class BookMarkSuccessState extends MainState {}

class BookMarkLoadingState extends MainState {}
