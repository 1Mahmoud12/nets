import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/auth/data/models/login_model.dart';

class LoginDataSource {
  static Future<Either<Failure, LoginModel>> login({required Map<String, dynamic> data}) async {
    try {
      final response = await DioHelper.postData( endPoint: EndPoints.login, data: data);
      if (response.statusCode == 200 && response.data['status'] == false) {
        return Left(ServerFailure(response.data['message']));
      } else {
        return right(LoginModel.fromJson(response.data));
      }
    } catch (error) {
      log('error register==$error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
