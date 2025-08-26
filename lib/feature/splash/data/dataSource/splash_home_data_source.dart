import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/core/utils/constants.dart';
import 'package:nets/feature/splash/data/model/splash_home_model.dart';

abstract class SplashHomeDataSourceInterface {
  Future<Either<Failure, SplashHomeModel>> getSplashHome();
}

class SplashHomeDataSourceImplementation implements SplashHomeDataSourceInterface {
  @override
  Future<Either<Failure, SplashHomeModel>> getSplashHome() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.generalEndpoint,
        query: {'url': EndPoints.splashAndHomePage, 'lang': arabicLanguage ? 'ar' : 'en'},
      );
      // logger.d(response.data);
      return right(SplashHomeModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
