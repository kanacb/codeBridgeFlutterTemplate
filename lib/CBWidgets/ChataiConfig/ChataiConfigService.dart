import '../../Utils/Services/CrudService.dart';
import 'ChataiConfig.dart';

class ChataiConfigService extends CrudService<ChataiConfig> {
  ChataiConfigService({String? query = ""})
      : super(
    'chataiConfig', // Endpoint for external tickets
    query,
    fromJson: (json) => ChataiConfig.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
