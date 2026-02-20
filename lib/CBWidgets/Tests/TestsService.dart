import '../../Utils/Services/CrudService.dart';
import 'Tests.dart';

class TestsService extends CrudService<Tests> {
  TestsService({String? query = ""})
      : super(
    'tests', // Endpoint for external tickets
    query,
    fromJson: (json) => Tests.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
