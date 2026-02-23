import '../../Utils/Services/CrudService.dart';
import 'LoginHistory.dart';

class LoginHistoriesService extends CrudService<LoginHistory> {
  LoginHistoriesService({String? query = ""})
      : super(
    'loginHistories', // Endpoint for external tickets
    query,
    fromJson: (json) => LoginHistory.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
