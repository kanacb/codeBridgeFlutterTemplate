import '../../Utils/Services/CrudService.dart';
import 'HelpSidebarContent.dart';

class HelpSidebarContentsService extends CrudService<HelpSidebarContent> {
  HelpSidebarContentsService({String? query = ""})
      : super(
    'helpSidebarContents', // Endpoint for external tickets
    query,
    fromJson: (json) => HelpSidebarContent.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
