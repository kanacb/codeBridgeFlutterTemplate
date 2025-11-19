import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

part 'JobStationInsideQueue.g.dart';

// this is for the object inside JobStationQueue
@HiveType(typeId: 47)
class JobStationInsideQueue {
  @HiveField(0)
  String? id; // not unique id for this object, but id for JobStations object

  @HiveField(1)
  String? underscoreId; // following the JobStationQueues.model.js.
                        // underscoreId instead of _id bcs I cant put underscoreId as named parameters

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? description;

  @HiveField(4)
  IdName? technicianId;

  JobStationInsideQueue({
    this.id,
    this.underscoreId, // Named parameters can't start with an underscore
    this.name,
    this.description,
    this.technicianId,
  });

  factory JobStationInsideQueue.fromJson(Map<String, dynamic> map) {
    return JobStationInsideQueue()
      ..id = map['id'] as String?
      ..underscoreId = map['_id'] as String?
      ..name = map['name'] as String?
      ..description = map['description'] as String?
      ..technicianId = map['technicianId'] == null
          ? null
          : IdName.fromJson(map['technicianId']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': underscoreId,
      'name': name,
      'description': description,
      'technicianId': technicianId,
    };
  }
}
