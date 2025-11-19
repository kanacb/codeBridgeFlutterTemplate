import '../../Utils/Services/CrudService.dart';
import '../../Widgets/ExternalChecks/ExternalChecks.dart';

class ExternalChecksService extends CrudService<ExternalChecks> {


  ExternalChecksService({String? query = ""})
      : super(
    'externalChecks', // Endpoint for external checks
    query,
    fromJson: (json) => ExternalChecks.fromJson(json),
    toJson: (check) => check.toJson(),
  );
}
