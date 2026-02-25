import '../../Utils/Services/CrudService.dart';
import 'Superior.dart';

class SuperiorsService extends CrudService<Superior> {
  SuperiorsService({String? query = ""})
      : super(
    'superiors', // Endpoint for external tickets
    query,
    fromJson: (json) => Superior.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
