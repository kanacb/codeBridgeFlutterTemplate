import '../../Utils/Services/CrudService.dart';
import 'CompanyPhone.dart';

class CompanyPhonesService extends CrudService<CompanyPhone> {
  CompanyPhonesService({String? query = ""})
      : super(
    'companyPhones', // Endpoint for external tickets
    query,
    fromJson: (json) => CompanyPhone.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
