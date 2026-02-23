import '../../Utils/Services/CrudService.dart';
import 'FcmMessage.dart';

class FcmMessagesService extends CrudService<FcmMessage> {
  FcmMessagesService({String? query = ""})
      : super(
    'fcmMessages', // Endpoint for external tickets
    query,
    fromJson: (json) => FcmMessage.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
