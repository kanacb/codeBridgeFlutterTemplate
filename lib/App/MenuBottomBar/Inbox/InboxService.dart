import '../../../Utils/Services/CrudService.dart';
import 'Inbox.dart';

class InboxService extends CrudService<Inbox> {
  InboxService()
      : super(
    "inbox",
    _buildQuery(),
    fromJson: (json) => Inbox.fromJson(json),
    toJson: (data) => data.toJson(),
  );

  static String _buildQuery() {
    final query = "\$limit=10000"
        "&\$populate[0][path]=createdBy"
        "&\$populate[0][service]=users"
        "&\$populate[0][select][0]=name"
        "&\$populate[1][path]=updatedBy"
        "&\$populate[1][service]=users"
        "&\$populate[1][select][0]=name"
        "&\$populate[2][path]=from"
        "&\$populate[2][service]=users"
        "&\$populate[2][select][0]=name"
        "&\$populate[3][path]=toUser"
        "&\$populate[3][service]=users"
        "&\$populate[3][select][0]=name";
    print("Stored query: $query");
    return query;
  }
}
