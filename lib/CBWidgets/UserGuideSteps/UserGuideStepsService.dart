import '../../Utils/Services/CrudService.dart';
import 'UserGuideStep.dart';

class UserGuideStepsService extends CrudService<UserGuideStep> {
  UserGuideStepsService({String? query = ""})
      : super(
    'userGuideSteps', // Endpoint for external tickets
    query,
    fromJson: (json) => UserGuideStep.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
