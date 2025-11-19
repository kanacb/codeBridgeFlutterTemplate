import '../../Utils/Services/CrudService.dart';


import 'CustomerPurchaseOrders.dart';

class CustomerPurchaseOrdersService extends CrudService<CustomerPurchaseOrders> {
  CustomerPurchaseOrdersService({String? query = ""})
      : super(
    'customerPurchaseOrders', // Endpoint for external tickets
    query,
    fromJson: (json) => CustomerPurchaseOrders.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
