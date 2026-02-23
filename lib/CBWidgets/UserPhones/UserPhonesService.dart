import '../../Utils/Services/CrudService.dart';
import 'UserPhone.dart';

class UserPhonesService extends CrudService<UserPhone> {
  UserPhonesService({String? query = ""})
      : super(
    'userPhones', // Endpoint for external tickets
    query,
    fromJson: (json) => UserPhone.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
