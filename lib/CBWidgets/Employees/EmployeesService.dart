import '../../Utils/Services/CrudService.dart';
import 'Employee.dart';

class EmployeesService extends CrudService<Employee> {
  EmployeesService({String? query = ""})
      : super(
    'employees', // Endpoint for external tickets
    query,
    fromJson: (json) => Employee.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
