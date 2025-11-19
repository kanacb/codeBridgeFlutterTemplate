import '../../../Utils/Services/CrudService.dart';
import 'CBNotification.dart';

class NotificationService extends CrudService<CBNotification> {
  NotificationService({String? query = ""})
    : super(
        "notifications",
        query,
        fromJson: (json) => CBNotification.fromJson(json),
        toJson: (data) => data.toJson(),
      );
}
