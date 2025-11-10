import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nets/feature/Contacts/data/datasource/contacts_data_source.dart';
import 'package:nets/feature/Contacts/data/models/contact_model.dart';
import 'package:nets/core/utils/constants_models.dart';
part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  Future<void> fetchContacts({String? search}) async {
    emit(ContactsLoading());
    final result = await ContactsDataSource.getContacts(search: search);
    result.fold((failure) => emit(ContactsError(failure.errMessage)), (contacts) {
      ConstantsModels.contactsModel = contacts;
      emit(ContactsSuccess(contacts));
    });
  }
}
