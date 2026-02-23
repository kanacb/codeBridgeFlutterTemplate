import '../../Utils/Services/CrudService.dart';
import 'Department.dart';

class DepartmentsService extends CrudService<Department> {
  DepartmentsService({String? query = ""})
      : super(
    'departments', // Endpoint for external tickets
    query,
    fromJson: (json) => Department.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
