import '../../Utils/Services/CrudService.dart';
import 'ChataiEnabler.dart';

class ChataiEnablerService extends CrudService<ChataiEnabler> {
  ChataiEnablerService({String? query = ""})
      : super(
    'chataiEnabler', // Endpoint for external tickets
    query,
    fromJson: (json) => ChataiEnabler.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
