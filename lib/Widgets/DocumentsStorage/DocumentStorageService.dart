import '../../Utils/Services/CrudService.dart';
import 'DocumentStorage.dart';

class DocumentStorageService extends CrudService<DocumentStorage> {
  DocumentStorageService({String? query = ""})
    : super(
        'documentStorages',
        query,
        fromJson: (json) => DocumentStorage.fromJson(json),
        toJson: (data) => data.toJson(),
      );
}
