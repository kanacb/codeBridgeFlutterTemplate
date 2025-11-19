import '../../Utils/Services/CrudService.dart';

import 'irmsDeliveryOrders.dart';

class irmsDeliveryOrdersService extends CrudService<irmsDeliveryOrders> {
  irmsDeliveryOrdersService({String? query = ""})
      : super(
    'irmsDeliveryOrders', // Endpoint for external tickets
    query,
    fromJson: (json) => irmsDeliveryOrders.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
