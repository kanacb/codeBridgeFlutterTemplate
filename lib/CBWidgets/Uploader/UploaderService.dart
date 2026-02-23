import '../../Utils/Services/CrudService.dart';
import 'Uploader.dart';

class UploaderService extends CrudService<Uploader> {
  UploaderService({String? query = ""})
      : super(
    'uploader', // Endpoint for external tickets
    query,
    fromJson: (json) => Uploader.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
