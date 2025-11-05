import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/profile/data/dataSource/user_data_source.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitial());
  Future<void> getUserData() async {
    emit(UserDataLoading());
    await UserDataSource.getUserData().then((value) {
      value.fold(
        (l) {
          emit(UserDataError(error: l.errMessage));
        },
        (r) {
          ConstantsModels.userDataModel = r;
          emit(UserDataSuccess());
        },
      );
    });
  }
}
