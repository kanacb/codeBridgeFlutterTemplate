import '../../Utils/Services/CrudService.dart';
import 'FcmQue.dart';

class FcmQuesService extends CrudService<FcmQue> {
  FcmQuesService({String? query = ""})
      : super(
    'fcmQues', // Endpoint for external tickets
    query,
    fromJson: (json) => FcmQue.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
