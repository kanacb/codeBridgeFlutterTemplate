import '../../Utils/Services/CrudService.dart';


import 'irmsQuotations.dart';

class irmsQuotationsService extends CrudService<irmsQuotations> {
  irmsQuotationsService({String? query = ""})
      : super(
    'irmsQuotations', // Endpoint for external tickets
    query,
    fromJson: (json) => irmsQuotations.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
