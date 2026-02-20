import '../../Utils/Services/CrudService.dart';
import 'UserPhones.dart';

class UserPhonesService extends CrudService<UserPhones> {
  UserPhonesService({String? query = ""})
      : super(
    'userPhones', // Endpoint for external tickets
    query,
    fromJson: (json) => UserPhones.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
