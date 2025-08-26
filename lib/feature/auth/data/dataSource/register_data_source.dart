import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/auth/data/models/login_model.dart';

import '../../../../main.dart';

class RegisterDataSource {
  static Future<Either<Failure, LoginModel>> register({required Map<String, dynamic> data}) async {
    try {
      final response = await DioHelper.postData(query: {'url': 'signup'}, endPoint: EndPoints.generalEndpoint, data: data);
      return right(LoginModel.fromJson(response.data));
    } catch (error) {
      log('error register==$error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, num>> sendOtp({required String email}) async {
    try {
      final response = await DioHelper.postData(query: {'url': EndPoints.otp}, endPoint: EndPoints.generalEndpoint, data: {'email': email});
      logger.d(response.data);
      return right(response.data['data'] as num);
    } catch (error) {
      log('error register==$error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, void>> verifyOtp({required String otp}) async {
    try {
      await DioHelper.postData(query: {'url': 'verify-otp'}, endPoint: EndPoints.generalEndpoint, data: {'otp': otp, 'type': 'signup'});
      return right(null);
    } catch (error) {
      log('error register==$error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
