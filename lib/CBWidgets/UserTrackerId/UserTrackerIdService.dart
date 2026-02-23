import '../../Utils/Services/CrudService.dart';
import 'UserTrackerId.dart';

class UserTrackerIdService extends CrudService<UserTrackerId> {
  UserTrackerIdService({String? query = ""})
      : super(
    'userTrackerId', // Endpoint for external tickets
    query,
    fromJson: (json) => UserTrackerId.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
