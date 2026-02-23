import '../../Utils/Services/CrudService.dart';
import 'Audit.dart';

class AuditsService extends CrudService<Audit> {
  AuditsService({String? query = ""})
      : super(
    'audits', // Endpoint for external tickets
    query,
    fromJson: (json) => Audit.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
