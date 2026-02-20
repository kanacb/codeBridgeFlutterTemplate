import '../../Utils/Services/CrudService.dart';
import 'Employees.dart';

class EmployeesService extends CrudService<Employees> {
  EmployeesService({String? query = ""})
      : super(
    'employees', // Endpoint for external tickets
    query,
    fromJson: (json) => Employees.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
