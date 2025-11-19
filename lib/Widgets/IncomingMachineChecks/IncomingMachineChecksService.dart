import '../../Utils/Services/CrudService.dart';
import 'IncomingMachineChecks.dart';


class IncomingMachineChecksService extends CrudService<IncomingMachineChecks> {
  IncomingMachineChecksService({String? query = ""})
      : super(
    'incomingMachineChecks', // Endpoint for incoming checks
    query,
    fromJson: (json) => IncomingMachineChecks.fromJson(json),
    toJson: (checks) => checks.toJson(),
  );
}
