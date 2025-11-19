import '../../Utils/Services/CrudService.dart';


import 'DisposalDetails.dart';

class DisposalDetailsService extends CrudService<DisposalDetails> {
  DisposalDetailsService({String? query = ""})
      : super(
    'disposalDetails', // Endpoint for external tickets
    query,
    fromJson: (json) => DisposalDetails.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
