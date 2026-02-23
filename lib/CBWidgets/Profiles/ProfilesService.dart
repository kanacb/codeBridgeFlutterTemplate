import '../../Utils/Services/CrudService.dart';
import 'Profile.dart';

class ProfilesService extends CrudService<Profile> {
  ProfilesService({String? query = ""})
      : super(
    'profiles', // Endpoint for external tickets
    query,
    fromJson: (json) => Profile.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
