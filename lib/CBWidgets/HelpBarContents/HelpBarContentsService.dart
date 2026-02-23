import '../../Utils/Services/CrudService.dart';
import 'HelpBarContent.dart';

class HelpBarContentsService extends CrudService<HelpBarContent> {
  HelpBarContentsService({String? query = ""})
      : super(
    'helpBarContents', // Endpoint for external tickets
    query,
    fromJson: (json) => HelpBarContent.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
