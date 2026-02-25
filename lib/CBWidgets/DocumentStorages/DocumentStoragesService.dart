import '../../Utils/Services/CrudService.dart';
import 'DocumentStorage.dart';

class DocumentStoragesService extends CrudService<DocumentStorage> {
  DocumentStoragesService({String? query = ""})
      : super(
    'documentStorages', // Endpoint for external tickets
    query,
    fromJson: (json) => DocumentStorage.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
