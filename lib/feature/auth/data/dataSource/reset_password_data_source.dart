import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/auth/data/models/login_model.dart';
import 'package:nets/feature/auth/data/models/otp_model.dart';
import 'package:nets/main.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/end_points.dart';

abstract class ResetPasswordDataSourceInterface {
  Future<Either<Failure, String>> resetPassword({
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, OtpModel>> otp({required String email});

  Future<Either<Failure, LoginModel>> verifyOtp({required String otp});
}

class ResetPasswordDataSourceImplementation
    implements ResetPasswordDataSourceInterface {
  @override
  Future<Either<Failure, String>> resetPassword({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.generalEndpoint,
        query: {'url': EndPoints.resetPassword},
        data: data,
      );
      return right(response.data['message']);
    } catch (error) {
      log('error resetPassword == $error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> otp({required String email}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.generalEndpoint,
        query: {'url': EndPoints.otp},
        data: {'email': email},
      );
      final otpModel = OtpModel.fromJson(response.data);
      logger.d(otpModel.toJson());
      return right(otpModel);
    } catch (error) {
      log('error resetPassword == $error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> verifyOtp({required String otp}) async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.generalEndpoint,
        query: {'url': EndPoints.verifyOtp},
        data: {'otp': otp},
      );
      final loginModel = LoginModel.fromJson(response.data);
      return right(loginModel);
    } catch (error) {
      log('error resetPassword == $error');
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
