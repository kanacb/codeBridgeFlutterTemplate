import '../../Utils/Services/CrudService.dart';
import '../../Widgets/MachineMaster/MachineMaster.dart';

class MachineMasterService extends CrudService<MachineMaster> {
  MachineMasterService({String? query = ""})
      : super(
    'machineMaster', // Endpoint for machine masters
    query,
    fromJson: (json) => MachineMaster.fromJson(json),
    toJson: (machineMaster) => machineMaster.toJson(),
  );
}
