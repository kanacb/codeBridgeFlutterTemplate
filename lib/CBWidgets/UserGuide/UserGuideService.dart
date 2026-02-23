import '../../Utils/Services/CrudService.dart';
import 'UserGuide.dart';

class UserGuideService extends CrudService<UserGuide> {
  UserGuideService({String? query = ""})
      : super(
    'userGuide', // Endpoint for external tickets
    query,
    fromJson: (json) => UserGuide.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
