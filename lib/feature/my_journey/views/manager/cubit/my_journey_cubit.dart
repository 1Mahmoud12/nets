import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/core/utils/constants_models.dart';
import 'package:nets/feature/my_journey/data/datasource/my_journey_data_source.dart';
import 'package:nets/feature/my_journey/data/models/journy_model.dart';

part 'my_journey_state.dart';

class MyJourneyCubit extends Cubit<MyJourneyState> {
  MyJourneyCubit() : super(MyJourneyInitial());

  Future<void> fetchJourneys({String? search, String? endDate, String? startDate}) async {
    emit(MyJourneyLoading());
    final result = await MyJourneyDataSource.getJourneys(search: search, endDate: endDate, startDate: startDate);
    result.fold((failure) => emit(MyJourneyError(failure.errMessage)), (journeyModel) {
      ConstantsModels.journeyModel = journeyModel;
      emit(MyJourneySuccess(journeyModel));
    });
  }
}
