import '../../Utils/Services/CrudService.dart';
import 'Branch.dart';

class BranchesService extends CrudService<Branch> {
  BranchesService({String? query = ""})
      : super(
    'branches', // Endpoint for external tickets
    query,
    fromJson: (json) => Branch.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
