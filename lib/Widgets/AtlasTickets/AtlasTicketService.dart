import '../../Utils/Services/CrudService.dart';

import 'AtlasTicket.dart';

class AtlasTicketService extends CrudService<AtlasTicket> {


  AtlasTicketService({String? query = ""})
      : super(
    'atlasTickets', // Endpoint for external tickets
    query,
    fromJson: (json) => AtlasTicket.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
