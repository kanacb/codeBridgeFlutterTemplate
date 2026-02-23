import '../../Utils/Services/CrudService.dart';
import 'MailQue.dart';

class MailQuesService extends CrudService<MailQue> {
  MailQuesService({String? query = ""})
      : super(
    'mailQues', // Endpoint for external tickets
    query,
    fromJson: (json) => MailQue.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
