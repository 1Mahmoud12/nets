import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nets/core/network/dio_helper.dart';
import 'package:nets/core/network/end_points.dart';
import 'package:nets/core/network/errors/failures.dart';
import 'package:nets/feature/Contacts/data/models/contact_model.dart';

class ContactsDataSource {
  static Future<Either<Failure, ContactModel>> getContacts({String? search}) async {
    try {
      final response = await DioHelper.getData(url: EndPoints.contacts, query: search != null ? {'search': search} : null);
      return right(ContactModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
