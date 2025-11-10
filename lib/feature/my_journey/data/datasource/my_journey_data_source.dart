import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/my_journey/data/models/journy_model.dart';

class MyJourneyDataSource {
  static Future<Either<Failure, JourneyModel>> getJourneys({String? search}) async {
    try {
      final response = await DioHelper.getData(url: EndPoints.journeys, query: search != null && search.isNotEmpty ? {'search': search} : null);
      return right(JourneyModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
