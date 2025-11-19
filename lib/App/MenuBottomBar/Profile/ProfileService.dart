import '../../../Utils/Services/CrudService.dart';
import 'Profile.dart';

class ProfileService extends CrudService<Profile> {
  ProfileService({String? query = ""})
      : super(
          "profiles",
          query,
          fromJson: (json) => Profile.fromJson(json),
          toJson: (data) => data.toJson(),
        );
}
