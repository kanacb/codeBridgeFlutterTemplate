import '../../Utils/Services/CrudService.dart';
import 'ErrorLog.dart';

class ErrorLogsService extends CrudService<ErrorLog> {
  ErrorLogsService({String? query = ""})
      : super(
    'errorLogs', // Endpoint for external tickets
    query,
    fromJson: (json) => ErrorLog.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
