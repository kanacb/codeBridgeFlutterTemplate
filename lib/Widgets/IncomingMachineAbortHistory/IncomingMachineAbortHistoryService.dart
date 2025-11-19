import '../../Utils/Services/CrudService.dart';
import 'IncomingMachineAbortHistory.dart';

class IncomingMachineAbortHistoryService extends CrudService<IncomingMachineAbortHistory> {
  IncomingMachineAbortHistoryService({String? query = ""})
      : super(
    'incomingMachineAbortHistory', // Endpoint for incomingMachineAbortHistory
    query,
    fromJson: (json) => IncomingMachineAbortHistory.fromJson(json),
    toJson: (incomingMachineAbortHistory) => incomingMachineAbortHistory.toJson(),
  );
}
