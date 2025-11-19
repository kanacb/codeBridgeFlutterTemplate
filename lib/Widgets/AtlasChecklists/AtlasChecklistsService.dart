import '../../Utils/Services/CrudService.dart';
import '../../Widgets/AtlasChecklists/AtlasChecklists.dart';

class AtlasChecklistsService extends CrudService<AtlasChecklists> {
  AtlasChecklistsService({String? query = ""})
      : super(
    'atlasChecklists', // Endpoint for external checklists
    query,
    fromJson: (json) => AtlasChecklists.fromJson(json),
    toJson: (checklist) => checklist.toJson(),
  );
}
