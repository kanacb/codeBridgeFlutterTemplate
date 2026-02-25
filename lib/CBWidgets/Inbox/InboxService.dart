import '../../Utils/Services/CrudService.dart';
import 'Inbox.dart';

class InboxService extends CrudService<Inbox> {
  InboxService({String? query = ""})
      : super(
    'inbox', // Endpoint for external tickets
    query,
    fromJson: (json) => Inbox.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
