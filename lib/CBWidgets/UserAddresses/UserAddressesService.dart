import '../../Utils/Services/CrudService.dart';
import 'UserAddresses.dart';

class UserAddressesService extends CrudService<UserAddresses> {
  UserAddressesService({String? query = ""})
      : super(
    'userAddresses', // Endpoint for external tickets
    query,
    fromJson: (json) => UserAddresses.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
