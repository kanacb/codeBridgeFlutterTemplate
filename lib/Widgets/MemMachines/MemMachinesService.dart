import '../../Utils/Services/CrudService.dart';
import 'MemMachines.dart';

class MemMachinesService extends CrudService<MemMachines> {
  MemMachinesService({String? query = ""})
      : super(
    'memMachines', // Endpoint for irms machines
    query,
    fromJson: (json) => MemMachines.fromJson(json),
    toJson: (memMachines) => memMachines.toJson(),
  );
}
