import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/core/utils/constants.dart';

abstract class HomeDataSourceInterface {
  Future<Either<Failure, void>> updateDeviceToken({required String fcmToken});
}

class HomeDataSourceImplementation implements HomeDataSourceInterface {
  @override
  Future<Either<Failure, void>> updateDeviceToken({required String fcmToken}) async {
    try {
      await DioHelper.postData(
        endPoint: EndPoints.generalEndpoint,
        query: {'url': EndPoints.updateDeviceToken},
        data: {
          'device_token': fcmToken,
          'device_type': Constants.deviceType,
          'device_id': Constants.deviceId,
          'device_os': Constants.deviceOs,
          'device_version': Constants.deviceVersion,
        },
      );
      // Utils.showToast(title: response.data['message'], state: UtilState.success);
      return right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
