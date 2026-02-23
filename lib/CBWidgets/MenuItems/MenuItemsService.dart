import '../../Utils/Services/CrudService.dart';
import 'MenuItem.dart';

class MenuItemsService extends CrudService<MenuItem> {
  MenuItemsService({String? query = ""})
      : super(
    'menuItems', // Endpoint for external tickets
    query,
    fromJson: (json) => MenuItem.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
