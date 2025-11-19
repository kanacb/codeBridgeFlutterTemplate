import '../../Utils/Services/CrudService.dart';
import 'VendingMachine.dart';

class VendingMachineService extends CrudService<VendingMachine> {
  VendingMachineService({String? query = ""})
      : super(
    'vendingMachines', // Endpoint for machine masters
    query,
    fromJson: (json) => VendingMachine.fromJson(json),
    toJson: (vendingMachine) => vendingMachine.toJson(),
  );
}
