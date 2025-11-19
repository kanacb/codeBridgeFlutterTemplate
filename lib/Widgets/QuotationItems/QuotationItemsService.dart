import '../../Utils/Services/CrudService.dart';


import 'QuotationItems.dart';

class QuotationItemsService extends CrudService<QuotationItems> {
  QuotationItemsService({String? query = ""})
      : super(
    'quotationItems', // Endpoint for external tickets
    query,
    fromJson: (json) => QuotationItems.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
