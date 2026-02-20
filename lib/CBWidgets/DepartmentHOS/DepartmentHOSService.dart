import '../../Utils/Services/CrudService.dart';
import 'DepartmentHOS.dart';

class DepartmentHOSService extends CrudService<DepartmentHOS> {
  DepartmentHOSService({String? query = ""})
      : super(
    'departmentHOS', // Endpoint for external tickets
    query,
    fromJson: (json) => DepartmentHOS.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
