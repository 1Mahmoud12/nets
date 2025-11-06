import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/feature/profile/data/dataSource/user_data_source.dart';
import 'package:nets/feature/profile/data/models/user_statistics_model.dart';

part 'get_user_statistics_state.dart';

class GetUserStatisticsCubit extends Cubit<GetUserStatisticsState> {
  GetUserStatisticsCubit() : super(GetUserStatisticsInitial());

  Future<void> getUserStatistics() async {
    emit(GetUserStatisticsLoading());
    final result = await UserDataSource.getUserStatistics();
    result.fold(
      (failure) => emit(GetUserStatisticsError(failure.errMessage)),
      (statistics) => emit(GetUserStatisticsSuccess(statistics)),
    );
  }
}
