import '../../Utils/Services/CrudService.dart';
import 'JobStationQueue.dart';

class JobStationQueueService extends CrudService<JobStationQueue> {
  JobStationQueueService({String? query = ""})
      : super(
    'jobStationQueues', // Endpoint for Job Station Queue
    query,
    fromJson: (json) => JobStationQueue.fromJson(json),
    toJson: (jobStationQueue) => jobStationQueue.toJson(),
  );
}
