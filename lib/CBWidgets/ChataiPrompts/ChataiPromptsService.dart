import '../../Utils/Services/CrudService.dart';
import 'ChataiPrompt.dart';

class ChataiPromptsService extends CrudService<ChataiPrompt> {
  ChataiPromptsService({String? query = ""})
      : super(
    'chataiPrompts', // Endpoint for external tickets
    query,
    fromJson: (json) => ChataiPrompt.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
