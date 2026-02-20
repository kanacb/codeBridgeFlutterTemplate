import '../../Utils/Services/CrudService.dart';
import 'Departments.dart';

class DepartmentsService extends CrudService<Departments> {
  DepartmentsService({String? query = ""})
      : super(
    'departments', // Endpoint for external tickets
    query,
    fromJson: (json) => Departments.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
