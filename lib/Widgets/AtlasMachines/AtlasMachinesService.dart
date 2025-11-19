import '../../Utils/Services/CrudService.dart';
import '../../Widgets/AtlasMachines/AtlasMachines.dart';

class AtlasMachinesService extends CrudService<AtlasMachines> {
  AtlasMachinesService({String? query = ""})
      : super(
    'atlasMachines', // Endpoint for atlas machines
    query,
    fromJson: (json) => AtlasMachines.fromJson(json),
    toJson: (atlasMachines) => atlasMachines.toJson(),
  );
}
