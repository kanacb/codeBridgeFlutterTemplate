
import '../../Utils/Services/CrudService.dart';
import 'User.dart';

class UserService extends CrudService<User> {
  UserService({String? query = ""})
      : super(
          'users',
          query,
          fromJson: (json) => User.fromJson(json),
          toJson: (user) => user.toJson(),
        );
}
