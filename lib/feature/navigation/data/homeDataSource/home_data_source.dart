import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/Contacts/views/presentation/contacts_view.dart';
import 'package:nets/main.dart';

abstract class HomeDataSourceInterface {
  Future<Either<Failure, void>> updateDeviceToken();
}

class HomeDataSourceImplementation implements HomeDataSourceInterface {
  @override
  Future<Either<Failure, void>> updateDeviceToken() async {
    try {
      final response = await DioHelper.postData(
        endPoint: EndPoints.checkLink,
        data: {},
      );
      if (response.data['exists'] == true) {
        showContactDetails({
          'name': 'Ahmed Hassan',
          'phone': '+20 123 456 7890',
          'email': 'ahmed.hassan@email.com',
          'status': 'online',
        }, navigatorKey.currentState!.context);
      }
      return right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
