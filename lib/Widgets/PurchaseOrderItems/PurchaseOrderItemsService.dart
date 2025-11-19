import '../../Utils/Services/CrudService.dart';


import 'PurchaseOrderItems.dart';

class PurchaseOrderItemsService extends CrudService<PurchaseOrderItems> {
  PurchaseOrderItemsService({String? query = ""})
      : super(
    'purchaseOrderItems', // Endpoint for external tickets
    query,
    fromJson: (json) => PurchaseOrderItems.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
