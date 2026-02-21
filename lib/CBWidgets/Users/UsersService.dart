import '../../Utils/Services/CrudService.dart';
import 'User.dart';

class UsersService extends CrudService<User> {
  UsersService({String? query = ""})
      : super(
    'users', // Endpoint for external tickets
    query,
    fromJson: (json) => User.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
