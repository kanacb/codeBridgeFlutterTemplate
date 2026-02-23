import '../../Utils/Services/CrudService.dart';
import 'DocumentStorage.dart';

class DocumentStorageService extends CrudService<DocumentStorage> {
  DocumentStorageService({String? query = ""})
      : super(
    'documentStorage', // Endpoint for external tickets
    query,
    fromJson: (json) => DocumentStorage.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
