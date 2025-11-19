import '../../Utils/Services/CrudService.dart';
import 'JobStations.dart';

class JobStationsService extends CrudService<JobStations> {
  JobStationsService({String? query = ""})
      : super(
    'jobStations', // Endpoint for machine masters
    query,
    fromJson: (json) => JobStations.fromJson(json),
    toJson: (jobStations) => jobStations.toJson(),
  );
}
