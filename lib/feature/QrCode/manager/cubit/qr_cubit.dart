import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/feature/QrCode/data/dataSource/qr_data_source.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());

  Future<void> saveQrCode({
    required String qrCodeData,
    required String phone,
    required String email,
    required String name,
    required String titleWork,
    required String notes,
    required String location,
  }) async {
    emit(QrLoading());
    final result = await QrCodeDataSource.saveQrCode({
      'qr_code_data': qrCodeData,
      'phone': phone,
      'email': email,
      'name': name,
      'title_work': titleWork,
      'notes': notes,
      'location': location,
    });
    result.fold((failure) => emit(QrError(failure.errMessage)), (_) => emit(QrSuccess()));
  }
}
