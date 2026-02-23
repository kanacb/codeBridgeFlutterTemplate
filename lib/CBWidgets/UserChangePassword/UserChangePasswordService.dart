import '../../Utils/Services/CrudService.dart';
import 'UserChangePassword.dart';

class UserChangePasswordService extends CrudService<UserChangePassword> {
  UserChangePasswordService({String? query = ""})
      : super(
    'userChangePassword', // Endpoint for external tickets
    query,
    fromJson: (json) => UserChangePassword.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
