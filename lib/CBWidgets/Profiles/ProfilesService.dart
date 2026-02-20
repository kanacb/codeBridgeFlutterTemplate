import '../../Utils/Services/CrudService.dart';
import 'Profiles.dart';

class ProfilesService extends CrudService<Profiles> {
  ProfilesService({String? query = ""})
      : super(
    'profiles', // Endpoint for external tickets
    query,
    fromJson: (json) => Profiles.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
