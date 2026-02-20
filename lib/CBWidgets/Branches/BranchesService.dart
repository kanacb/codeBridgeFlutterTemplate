import '../../Utils/Services/CrudService.dart';
import 'Branches.dart';

class BranchesService extends CrudService<Branches> {
  BranchesService({String? query = ""})
      : super(
    'branches', // Endpoint for external tickets
    query,
    fromJson: (json) => Branches.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
