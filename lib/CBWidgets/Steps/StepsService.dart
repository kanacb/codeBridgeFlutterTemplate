import '../../Utils/Services/CrudService.dart';
import 'Steps.dart';

class StepsService extends CrudService<Steps> {
  StepsService({String? query = ""})
      : super(
    'steps', // Endpoint for external tickets
    query,
    fromJson: (json) => Steps.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
