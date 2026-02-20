import '../../Utils/Services/CrudService.dart';
import 'Companies.dart';

class CompaniesService extends CrudService<Companies> {
  CompaniesService({String? query = ""})
      : super(
    'companies', // Endpoint for external tickets
    query,
    fromJson: (json) => Companies.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
