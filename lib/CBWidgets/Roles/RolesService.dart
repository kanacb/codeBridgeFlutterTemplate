import '../../Utils/Services/CrudService.dart';
import 'Role.dart';

class RolesService extends CrudService<Role> {
  RolesService({String? query = ""})
      : super(
    'roles', // Endpoint for external tickets
    query,
    fromJson: (json) => Role.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
