import '../../Utils/Services/CrudService.dart';


import 'SalesOrderItems.dart';

class SalesOrderItemsService extends CrudService<SalesOrderItems> {
  SalesOrderItemsService({String? query = ""})
      : super(
    'salesOrderItems', // Endpoint for external tickets
    query,
    fromJson: (json) => SalesOrderItems.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
