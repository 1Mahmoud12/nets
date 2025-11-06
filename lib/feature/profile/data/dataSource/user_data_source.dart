import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/profile/data/models/user_data_model.dart';
import 'package:nets/feature/profile/data/models/user_data_param.dart';
import 'package:nets/feature/profile/data/models/user_statistics_model.dart';

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
  static Future<Either<Failure, UserStatisticsModel>> getUserStatistics() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.userStatistics);
      return right(UserStatisticsModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> updateUserData(UserDataParam userData) async {
    try {
      await DioHelper.putData(endPoint: EndPoints.userData, data: userData.toJson());
      return right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
  static Future<Either<Failure, void>> updateUserImage(dynamic data) async {
    try {
      await DioHelper.postData( formDataIsEnabled: true, endPoint: EndPoints.userData, data: data);
      return right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
