import '../../Utils/Services/CrudService.dart';
import 'UserInvite.dart';

class UserInviteService extends CrudService<UserInvite> {
  UserInviteService({ String query = ""})
      : super(
    'userInvites',
    query,
    fromJson: (json) => UserInvite.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
