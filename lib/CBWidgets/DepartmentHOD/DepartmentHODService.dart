import '../../Utils/Services/CrudService.dart';
import 'DepartmentHOD.dart';

class DepartmentHODService extends CrudService<DepartmentHOD> {
  DepartmentHODService({String? query = ""})
      : super(
    'departmentHOD', // Endpoint for external tickets
    query,
    fromJson: (json) => DepartmentHOD.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
