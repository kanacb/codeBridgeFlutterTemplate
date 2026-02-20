import '../../Utils/Services/CrudService.dart';
import 'DepartmentHO.dart';

class DepartmentHOSService extends CrudService<DepartmentHO> {
  DepartmentHOSService({String? query = ""})
      : super(
    'departmentHOS', // Endpoint for external tickets
    query,
    fromJson: (json) => DepartmentHO.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
