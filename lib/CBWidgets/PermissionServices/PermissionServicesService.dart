import '../../Utils/Services/CrudService.dart';
import 'PermissionService.dart';

class PermissionServicesService extends CrudService<PermissionService> {
  PermissionServicesService({String? query = ""})
      : super(
    'permissionServices', // Endpoint for external tickets
    query,
    fromJson: (json) => PermissionService.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
