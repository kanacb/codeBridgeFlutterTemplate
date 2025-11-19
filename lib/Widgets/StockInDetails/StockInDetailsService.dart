import '../../Utils/Services/CrudService.dart';


import 'StockInDetails.dart';

class StockInDetailsService extends CrudService<StockInDetails> {
  StockInDetailsService({String? query = ""})
      : super(
    'stockInDetails', // Endpoint for external tickets
    query,
    fromJson: (json) => StockInDetails.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
