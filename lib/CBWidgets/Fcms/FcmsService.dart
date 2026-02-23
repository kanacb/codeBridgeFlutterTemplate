import '../../Utils/Services/CrudService.dart';
import 'Fcm.dart';

class FcmsService extends CrudService<Fcm> {
  FcmsService({String? query = ""})
      : super(
    'fcms', // Endpoint for external tickets
    query,
    fromJson: (json) => Fcm.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
