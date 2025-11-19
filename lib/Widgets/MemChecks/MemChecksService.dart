import '../../Utils/Services/CrudService.dart';
import 'MemChecks.dart';


class MemChecksService extends CrudService<MemChecks> {
  MemChecksService({String? query = ""})
      : super(
    'memChecks', // Endpoint for incoming checks
    query,
    fromJson: (json) => MemChecks.fromJson(json),
    toJson: (checks) => checks.toJson(),
  );
}
