import '../../Utils/Services/CrudService.dart';
import 'UserAddress.dart';

class UserAddressesService extends CrudService<UserAddress> {
  UserAddressesService({String? query = ""})
      : super(
    'userAddresses', // Endpoint for external tickets
    query,
    fromJson: (json) => UserAddress.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
