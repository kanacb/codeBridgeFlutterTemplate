import '../../Utils/Services/CrudService.dart';

import 'ExternalTickets.dart';


class ExternalTicketsService extends CrudService<ExternalTickets> {
  ExternalTicketsService({String? query = ""})
      : super(
    'externalTickets', // Endpoint for external tickets
    query,
    fromJson: (json) => ExternalTickets.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
