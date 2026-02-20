import '../../Utils/Services/CrudService.dart';
import 'CompanyPhones.dart';

class CompanyPhonesService extends CrudService<CompanyPhones> {
  CompanyPhonesService({String? query = ""})
      : super(
    'companyPhones', // Endpoint for external tickets
    query,
    fromJson: (json) => CompanyPhones.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
