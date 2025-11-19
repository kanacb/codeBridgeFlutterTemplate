import '../../Utils/Services/CrudService.dart';


import 'WarehouseMaster.dart';

class WarehouseMasterService extends CrudService<WarehouseMaster> {
  WarehouseMasterService({String? query = ""})
      : super(
    'warehouseMaster', // Endpoint for external tickets
    query,
    fromJson: (json) => WarehouseMaster.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
