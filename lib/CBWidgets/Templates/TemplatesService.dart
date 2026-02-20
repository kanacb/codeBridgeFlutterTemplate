import '../../Utils/Services/CrudService.dart';
import 'Template.dart';

class TemplatesService extends CrudService<Template> {
  TemplatesService({String? query = ""})
      : super(
    'templates', // Endpoint for external tickets
    query,
    fromJson: (json) => Template.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
