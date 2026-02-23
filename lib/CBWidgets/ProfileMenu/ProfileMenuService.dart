import '../../Utils/Services/CrudService.dart';
import 'ProfileMenu.dart';

class ProfileMenuService extends CrudService<ProfileMenu> {
  ProfileMenuService({String? query = ""})
      : super(
    'profileMenu', // Endpoint for external tickets
    query,
    fromJson: (json) => ProfileMenu.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
