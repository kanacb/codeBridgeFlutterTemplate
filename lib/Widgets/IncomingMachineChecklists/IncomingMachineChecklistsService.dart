import '../../Utils/Services/CrudService.dart';
import 'IncomingMachineChecklists.dart';


class IncomingMachineChecklistsService extends CrudService<IncomingMachineChecklists> {
  IncomingMachineChecklistsService({String? query = ""})
      : super(
    'incomingMachineChecklists', // Endpoint for incoming checklists
    query,
    fromJson: (json) => IncomingMachineChecklists.fromJson(json),
    toJson: (checklists) => checklists.toJson(),
  );
}
