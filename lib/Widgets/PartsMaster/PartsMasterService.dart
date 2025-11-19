import '../../Utils/Services/CrudService.dart';
import 'PartsMaster.dart';

class PartsMasterService extends CrudService<PartsMaster> {
  PartsMasterService({String? query = ""})
      : super(
    'partsMaster', // Endpoint for machine masters
    query,
    fromJson: (json) => PartsMaster.fromJson(json),
    toJson: (partsMaster) => partsMaster.toJson(),
  );
}
