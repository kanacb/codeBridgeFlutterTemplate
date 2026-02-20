import '../../Utils/Services/CrudService.dart';
import 'Users.dart';

class UsersService extends CrudService<Users> {
  UsersService({String? query = ""})
      : super(
    'users', // Endpoint for external tickets
    query,
    fromJson: (json) => Users.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
