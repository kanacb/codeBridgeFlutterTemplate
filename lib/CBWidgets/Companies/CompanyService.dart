import '../../Utils/Services/CrudService.dart';

import 'Companies.dart';

class CompanyService extends CrudService<Companies> {

  final String query = "";
  CompanyService({String? query = ""})
      : super(
    'companies', // Endpoint for external tickets
    query,
    fromJson: (json) => Companies.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
