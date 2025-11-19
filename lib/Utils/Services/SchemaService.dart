import 'CrudService.dart';
import 'Schema.dart';

class SchemaService extends CrudService<Schema> {
  SchemaService()
      : super(
    '',
    null,
    fromJson: (json) => Schema.fromJson(json),
    toJson: (schema) => schema.toJson(),
  );
}