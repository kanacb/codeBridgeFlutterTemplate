import '../../Utils/Services/CrudService.dart';
import 'IrmsWarehouseParts.dart';

class IrmsWarehousePartsService extends CrudService<IrmsWarehouseParts> {
  IrmsWarehousePartsService({String? query = ""})
      : super(
    'irmsWarehouseParts', // Endpoint for Irms Warehouse Parts
    query,
    fromJson: (json) => IrmsWarehouseParts.fromJson(json),
    toJson: (irmsWarehouseParts) => irmsWarehouseParts.toJson(),
  );
}
