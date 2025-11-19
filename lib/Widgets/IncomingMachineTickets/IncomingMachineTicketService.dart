import '../../Utils/Services/CrudService.dart';

import 'IncomingMachineTicket.dart';

class IncomingMachineTicketService extends CrudService<IncomingMachineTicket> {
  IncomingMachineTicketService({String? query = ""})
      : super(
    'incomingMachineTickets', // Endpoint for external tickets
    query,
    fromJson: (json) => IncomingMachineTicket.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
