import '../../Utils/Services/CrudService.dart';


import 'StockOutDetails.dart';

class StockOutDetailsService extends CrudService<StockOutDetails> {
  StockOutDetailsService({String? query = ""})
      : super(
    'StockOutDetails', // Endpoint for external tickets
    query,
    fromJson: (json) => StockOutDetails.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
