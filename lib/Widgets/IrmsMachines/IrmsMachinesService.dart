import '../../Utils/Services/CrudService.dart';
import '../../Widgets/IrmsMachines/IrmsMachines.dart';

class IrmsMachinesService extends CrudService<IrmsMachines> {
  IrmsMachinesService({String? query = ""})
      : super(
    'irmsMachines', // Endpoint for irms machines
    query,
    fromJson: (json) => IrmsMachines.fromJson(json),
    toJson: (irmsMachines) => irmsMachines.toJson(),
  );
}
