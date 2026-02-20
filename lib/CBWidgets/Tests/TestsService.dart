import '../../Utils/Services/CrudService.dart';
import 'Test.dart';

class TestsService extends CrudService<Test> {
  TestsService({String? query = ""})
      : super(
    'tests', // Endpoint for external tickets
    query,
    fromJson: (json) => Test.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
