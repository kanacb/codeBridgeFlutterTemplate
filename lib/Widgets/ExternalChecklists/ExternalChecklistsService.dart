import '../../Utils/Services/CrudService.dart';
import '../../Widgets/ExternalChecklists/ExternalChecklists.dart';

class ExternalChecklistsService extends CrudService<ExternalChecklists> {
  ExternalChecklistsService({String? query = ""})
      : super(
    'externalChecklists', // Endpoint for external checklists
    query,
    fromJson: (json) => ExternalChecklists.fromJson(json),
    toJson: (checklist) => checklist.toJson(),
  );
}
