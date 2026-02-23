import '../../Utils/Services/CrudService.dart';
import 'UserInvite.dart';

class UserInvitesService extends CrudService<UserInvite> {
  UserInvitesService({String? query = ""})
      : super(
    'userInvites', // Endpoint for external tickets
    query,
    fromJson: (json) => UserInvite.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
