import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/profile/data/models/user_data_model.dart';

class UserDataSource {
  static Future<Either<Failure, UserDataModel>> getUserData() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.userData);
      return right(UserDataModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
