import '../../Utils/Services/CrudService.dart';
import 'Templates.dart';

class TemplatesService extends CrudService<Templates> {
  TemplatesService({String? query = ""})
      : super(
    'templates', // Endpoint for external tickets
    query,
    fromJson: (json) => Templates.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
