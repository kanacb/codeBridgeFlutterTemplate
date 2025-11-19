import '../../Utils/Services/CrudService.dart';

import 'MemTicket.dart';

class MemTicketService extends CrudService<MemTicket> {
  MemTicketService({String? query = ""})
      : super(
    'memTickets', // Endpoint for external tickets
    query,
    fromJson: (json) => MemTicket.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
