import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';

class QrCodeDataSource {
  static Future<Either<Failure, void>> saveQrCode(Map<String, dynamic> data) async {
    try {
      await DioHelper.postData(endPoint: EndPoints.saveQrCode, data: data);
      return right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
