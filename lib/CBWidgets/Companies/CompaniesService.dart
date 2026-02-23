import '../../Utils/Services/CrudService.dart';
import 'Company.dart';

class CompaniesService extends CrudService<Company> {
  CompaniesService({String? query = ""})
      : super(
    'companies', // Endpoint for external tickets
    query,
    fromJson: (json) => Company.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
