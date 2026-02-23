import '../../Utils/Services/CrudService.dart';
import 'Position.dart';

class PositionsService extends CrudService<Position> {
  PositionsService({String? query = ""})
      : super(
    'positions', // Endpoint for external tickets
    query,
    fromJson: (json) => Position.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
