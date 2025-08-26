import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nets/core/network/local/cache.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/feature/auth/views/presentation/login_view.dart';
import 'package:nets/main.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioException(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.badResponse:
        log('badResponse on url ${dioError.response?.realUri}');
        log('badResponse on statusCode ${dioError.response?.statusCode}');
        log("badResponse on dataSource ${dioError.response?.data.runtimeType} ''${dioError.response?.data}'' ");

        return ServerFailure.fromResponse(dioError.response?.statusCode, dioError.response?.data);
      case DioExceptionType.badCertificate:
        return ServerFailure('Bad Certificate with ApiServer');
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceld');
      case DioExceptionType.connectionError:
        // print('=======> ${Constants.noInternet} <=========');
        //
        // if (!Constants.noInternet) {
        //   navigatorKey.currentState!.pushReplacement(
        //     MaterialPageRoute(
        //       builder: (context) => const StopInternetWidget(),
        //       settings: const RouteSettings(name: 'StopInternetPage'),
        //     ),
        //   );
        // }
        return ServerFailure('No Internet Connection');

      case DioExceptionType.unknown:
        return ServerFailure('Unexpected Error, Please try again!');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403 || statusCode == 404 || statusCode == 422 || statusCode == 302) {
      if (response != null &&
          response['message'] != null &&
          (response['message'].toString().toLowerCase().contains('token is expired') ||
              response['message'].toString().toLowerCase().contains('authorization token not found'))) {
        try {
          Future.delayed(Duration.zero, () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => const LoginView()));
          });
          Constants.token = '';
          userCache?.put(userCacheKey, '{}');
        } catch (e) {
          log('error in put value in hive $e');
        }
      }
      return ServerFailure(response['message'].toString());
    } else if (statusCode == 404) {
      return ServerFailure('your_request_not_found_please_try_later'.tr());
    } else if (statusCode == 500) {
      // log('object::>> ${response}');
      return ServerFailure('internal_server_error_please_try_later'.tr());
    } else {
      log('what is wrong ==> $response');

      return ServerFailure('opps_there_was_an_error,_please_try_again'.tr());
    }
  }
}
