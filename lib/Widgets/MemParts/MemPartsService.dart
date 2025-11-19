import '../../Utils/Services/CrudService.dart';
import 'MemParts.dart';

class MemPartsService extends CrudService<MemParts> {
  MemPartsService({String? query = ""})
      : super(
    'memParts', // Endpoint for Mem Parts
    query,
    fromJson: (json) => MemParts.fromJson(json),
    toJson: (memParts) => memParts.toJson(),
  );
}
