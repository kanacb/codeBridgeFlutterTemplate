import '../../Utils/Services/CrudService.dart';
import 'PermissionField.dart';

class PermissionFieldsService extends CrudService<PermissionField> {
  PermissionFieldsService({String? query = ""})
      : super(
    'permissionFields', // Endpoint for external tickets
    query,
    fromJson: (json) => PermissionField.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
