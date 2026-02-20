import '../../Utils/Services/CrudService.dart';
import 'CompanyAddresses.dart';

class CompanyAddressesService extends CrudService<CompanyAddresses> {
  CompanyAddressesService({String? query = ""})
      : super(
    'companyAddresses', // Endpoint for external tickets
    query,
    fromJson: (json) => CompanyAddresses.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
