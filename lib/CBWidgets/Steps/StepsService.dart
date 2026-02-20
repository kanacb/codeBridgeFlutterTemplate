import '../../Utils/Services/CrudService.dart';
import 'Step.dart';

class StepsService extends CrudService<Step> {
  StepsService({String? query = ""})
      : super(
    'steps', // Endpoint for external tickets
    query,
    fromJson: (json) => Step.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
