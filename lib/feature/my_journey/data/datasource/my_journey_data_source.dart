import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/my_journey/data/models/journy_model.dart';

class MyJourneyDataSource {
  static Future<Either<Failure, JourneyModel>> getJourneys({String? search,String?endDate,String?startDate}) async {
    try {
      final response = await DioHelper.getData(url: EndPoints.journeys, query: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (endDate != null && endDate.isNotEmpty) 'end_date': endDate,
        if (startDate != null && startDate.isNotEmpty) 'start_date': startDate,
      });
      return right(JourneyModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
