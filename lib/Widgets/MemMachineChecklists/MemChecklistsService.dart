import '../../Utils/Services/CrudService.dart';
import 'MemChecklists.dart';


class MemChecklistsService extends CrudService<MemChecklists> {
  MemChecklistsService({String? query = ""})
      : super(
    'memChecklists', // Endpoint for incoming checklists
    query,
    fromJson: (json) => MemChecklists.fromJson(json),
    toJson: (jobStations) => jobStations.toJson(),
  );
}
