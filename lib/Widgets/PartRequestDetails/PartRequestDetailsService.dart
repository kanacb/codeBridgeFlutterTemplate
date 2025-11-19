import '../../Utils/Services/CrudService.dart';
import 'PartRequestDetails.dart';

class PartRequestDetailsService extends CrudService<PartRequestDetails> {
  PartRequestDetailsService({String? query = ""})
      : super(
    'partRequestDetails', // Endpoint for external tickets
    query,
    fromJson: (json) => PartRequestDetails.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
