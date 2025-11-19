import '../../Utils/Services/CrudService.dart';


import 'CustomerSalesOrders.dart';

class CustomerSalesOrdersService extends CrudService<CustomerSalesOrders> {
  CustomerSalesOrdersService({String? query = ""})
      : super(
    'customerSalesOrders', // Endpoint for external tickets
    query,
    fromJson: (json) => CustomerSalesOrders.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
