import '../../Utils/Services/CrudService.dart';
import 'Positions.dart';

class PositionsService extends CrudService<Positions> {
  PositionsService({String? query = ""})
      : super(
    'positions', // Endpoint for Positions Parts
    query,
    fromJson: (json) => Positions.fromJson(json),
    toJson: (positions) => positions.toJson(),
  );
}
