import '../../Utils/Services/CrudService.dart';
import 'CompanyAddress.dart';

class CompanyAddressesService extends CrudService<CompanyAddress> {
  CompanyAddressesService({String? query = ""})
      : super(
    'companyAddresses', // Endpoint for external tickets
    query,
    fromJson: (json) => CompanyAddress.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
