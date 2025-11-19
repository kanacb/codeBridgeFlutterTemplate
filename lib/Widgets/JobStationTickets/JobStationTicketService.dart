import '../../Utils/Services/CrudService.dart';


import 'JobStationTicket.dart';

class JobStationTicketService extends CrudService<JobStationTicket> {
  JobStationTicketService({String? query = ""})
      : super(
    'jobStationTickets', // Endpoint for job station tickets
    query,
    fromJson: (json) => JobStationTicket.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
