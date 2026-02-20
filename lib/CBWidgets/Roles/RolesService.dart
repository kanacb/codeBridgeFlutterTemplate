import '../../Utils/Services/CrudService.dart';
import 'Roles.dart';

class RolesService extends CrudService<Roles> {
  RolesService({String? query = ""})
      : super(
    'roles', // Endpoint for external tickets
    query,
    fromJson: (json) => Roles.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
