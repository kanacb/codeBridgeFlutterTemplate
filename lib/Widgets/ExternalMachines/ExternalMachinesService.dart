import '../../Utils/Services/CrudService.dart';
import 'ExternalMachines.dart';

class ExternalMachinesService extends CrudService<ExternalMachines> {
  ExternalMachinesService({String? query = ""})
      : super(
    'externalMachines', // Endpoint for irms machines
    query,
    fromJson: (json) => ExternalMachines.fromJson(json),
    toJson: (externalMachines) => externalMachines.toJson(),
  );
}
