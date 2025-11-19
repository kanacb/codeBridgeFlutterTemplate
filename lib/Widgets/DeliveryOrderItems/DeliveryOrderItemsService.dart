import '../../Utils/Services/CrudService.dart';


import 'DeliveryOrderItems.dart';

class DeliveryOrderItemsService extends CrudService<DeliveryOrderItems> {
  DeliveryOrderItemsService({String? query = ""})
      : super(
    'deliveryOrderItems', // Endpoint for external tickets
    query,
    fromJson: (json) => DeliveryOrderItems.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
