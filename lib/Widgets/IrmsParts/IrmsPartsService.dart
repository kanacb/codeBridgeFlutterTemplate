import '../../Utils/Services/CrudService.dart';
import 'IrmsParts.dart';

class IrmsPartsService extends CrudService<IrmsParts> {
  IrmsPartsService({String? query = ""})
      : super(
    'irmsParts', // Endpoint for Irms Parts
    query,
    fromJson: (json) => IrmsParts.fromJson(json),
    toJson: (irmsParts) => irmsParts.toJson(),
  );
}
