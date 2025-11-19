import '../../Utils/Services/CrudService.dart';
import '../../Widgets/AtlasChecks/AtlasChecks.dart';

class AtlasChecksService extends CrudService<AtlasChecks> {
  AtlasChecksService({String? query = ""})
      : super(
    'atlasChecks', // Endpoint for external checks
    query,
    fromJson: (json) => AtlasChecks.fromJson(json),
    toJson: (check) => check.toJson(),
  );
}
