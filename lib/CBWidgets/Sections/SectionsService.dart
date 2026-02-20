import '../../Utils/Services/CrudService.dart';
import 'Section.dart';

class SectionsService extends CrudService<Section> {
  SectionsService({String? query = ""})
      : super(
    'sections', // Endpoint for external tickets
    query,
    fromJson: (json) => Section.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
