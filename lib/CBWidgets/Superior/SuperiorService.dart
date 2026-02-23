import '../../Utils/Services/CrudService.dart';
import 'Superior.dart';

class SuperiorService extends CrudService<Superior> {
  SuperiorService({String? query = ""})
      : super(
    'superior', // Endpoint for external tickets
    query,
    fromJson: (json) => Superior.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
