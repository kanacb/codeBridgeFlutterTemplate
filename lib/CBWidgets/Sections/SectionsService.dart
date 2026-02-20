import '../../Utils/Services/CrudService.dart';
import 'Sections.dart';

class SectionsService extends CrudService<Sections> {
  SectionsService({String? query = ""})
      : super(
    'sections', // Endpoint for external tickets
    query,
    fromJson: (json) => Sections.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
