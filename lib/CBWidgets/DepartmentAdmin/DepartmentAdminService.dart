import '../../Utils/Services/CrudService.dart';
import 'DepartmentAdmin.dart';

class DepartmentAdminService extends CrudService<DepartmentAdmin> {
  DepartmentAdminService({String? query = ""})
      : super(
    'departmentAdmin', // Endpoint for external tickets
    query,
    fromJson: (json) => DepartmentAdmin.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
