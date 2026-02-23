import '../../Utils/Services/CrudService.dart';
import 'Staffinfo.dart';

class StaffinfoService extends CrudService<Staffinfo> {
  StaffinfoService({String? query = ""})
      : super(
    'staffinfo', // Endpoint for external tickets
    query,
    fromJson: (json) => Staffinfo.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
