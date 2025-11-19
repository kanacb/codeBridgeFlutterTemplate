import '../../Utils/Services/CrudService.dart';


import 'TransferDetails.dart';

class TransferDetailsService extends CrudService<TransferDetails> {
  TransferDetailsService({String? query = ""})
      : super(
    'transferDetails', // Endpoint for external tickets
    query,
    fromJson: (json) => TransferDetails.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
