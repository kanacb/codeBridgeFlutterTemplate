import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'AtlasTicket.g.dart';

@HiveType(typeId: 8)
class AtlasTicket {
  @HiveField(0)
  final String? id; // Checklist ID (optional, for backend records)
  @HiveField(1)
  final List<String>? checklistResponse;
  @HiveField(2)
  final IdName? vendingController;
  @HiveField(3)
  final IdName? assignedSupervisor;
  @HiveField(4)
  final IdName? assignedTechnician;
  @HiveField(5)
  final String? status;
  @HiveField(6)
  final DateTime? startTime;
  @HiveField(7)
  final DateTime? endTime;
  @HiveField(8)
  final String? machineId;
  @HiveField(9)
  final DateTime? supervisorStartTime;
  @HiveField(10)
  final DateTime? supervisorEndTime;
  @HiveField(11)
  final DateTime? technicianStartTime;
  @HiveField(12)
  final DateTime? technicianEndTime;
  @HiveField(13)
  final String? comments;
  @HiveField(14)
  final String? technicianComments;
  @HiveField(15)
  final List<String>? machineImage;
  @HiveField(16)
  final List<String>? uploadOfPictureBeforeRepair;
  @HiveField(17)
  final List<String>? uploadOfPictureAfterRepair;
  @HiveField(18)
  IdName? createdBy;
  @HiveField(19)
  IdName? updatedBy;
  @HiveField(20)
  DateTime createdAt;
  @HiveField(21)
  DateTime updatedAt;

  AtlasTicket({
    this.id,
    this.checklistResponse,
    this.assignedSupervisor,
    this.assignedTechnician,
    this.vendingController,
    required this.status,
    this.startTime,
    this.endTime,
    required this.machineId,
    this.supervisorEndTime,
    this.supervisorStartTime,
    this.technicianStartTime,
    this.technicianEndTime,
    this.machineImage,
    this.comments,
    this.technicianComments,
    this.uploadOfPictureAfterRepair,
    this.uploadOfPictureBeforeRepair,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AtlasTicket.fromJson(Map<String, dynamic> map) {
    try {
      return AtlasTicket(
        id :
            map['_id'] as String?,
        checklistResponse:
            map['checklistResponse'].cast<String>(),
        vendingController:
            map['vendingController'] == null ? null : IdName.fromJson(map['vendingController']),
        assignedSupervisor:
            map['assignedSupervisor'] == null ? null : IdName.fromJson(map['assignedSupervisor']),
        assignedTechnician:
            map['assignedTechnician'] == null ? null : IdName.fromJson(map['assignedTechnician']),
        status:
            map['status'] as String?,
        startTime:
            map['startTime'] == null ? null : DateTime.parse(map['startTime']),
        endTime:
            map['endTime'] == null ? null : DateTime.parse(map['endTime']),
        supervisorStartTime:
            map['supervisorStartTime'] == null ? null : DateTime.parse(map['supervisorStartTime']),
        supervisorEndTime:
            map['supervisorEndTime'] == null ? null : DateTime.parse(map['supervisorEndTime']),
        technicianStartTime:
            map['technicianStartTime'] == null ? null : DateTime.parse(map['technicianStartTime']),
        technicianEndTime:
            map['technicianEndTime'] == null ? null : DateTime.parse(map['technicianEndTime']),
        machineId:
            map['machineId'] as String?,
        machineImage:
            (map['machineImage'] as List?)?.cast<String>(),
        uploadOfPictureBeforeRepair:
            (map['uploadOfPictureBeforeRepair'] as List?)?.cast<String>(),
        uploadOfPictureAfterRepair:
            (map['uploadOfPictureAfterRepair'] as List?)?.cast<String>(),
        comments:
            map['comments'] as String?,
        technicianComments:
        map['technicianComments'] as String?,
        createdBy:
            map['createdBy'] == null ? null : IdName.fromJson(map['createdBy']),
        updatedBy:
            map['updatedBy'] == null ? null : IdName.fromJson(map['updatedBy']),
        createdAt:
            DateTime.parse(map['createdAt']),
        updatedAt:
            DateTime.parse(map['updatedAt']),
      );
    } catch (e) {
      print("AtlasTicket error: $e");
      return AtlasTicket(
        id : "err",
        checklistResponse: [''],
        vendingController: IdName.fromJson({"_id": "_id", "name": "name"}),
        assignedSupervisor: IdName.fromJson({"_id": "_id", "name": "name"}),
        assignedTechnician: IdName.fromJson({"_id": "_id", "name": "name"}),
        status: "status",
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        supervisorStartTime: DateTime.now(),
        supervisorEndTime: DateTime.now(),
        technicianStartTime: DateTime.now(),
        technicianEndTime: DateTime.now(),
        machineId: map['machineId'] as String?,
        machineImage: ['machineImage'],
        uploadOfPictureBeforeRepair: ['uploadOfPictureBeforeRepair'],
        uploadOfPictureAfterRepair: ['uploadOfPictureAfterRepair'],
        comments: "comments",
        createdBy: IdName.fromJson({"_id": "_id", "name": "name"}),
        updatedBy: IdName.fromJson({"_id": "_id", "name": "name"}),
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checklistResponse'] = checklistResponse;
    data['vendingController'] = vendingController;
    data['assignedSupervisor'] = assignedSupervisor;
    data['assignedTechnician'] = assignedTechnician;
    data['status'] = status;
    data['startTime'] = startTime?.toIso8601String();
    data['endTime'] = endTime?.toIso8601String();
    data['machineId'] = machineId;
    data['supervisorStartTime'] = supervisorStartTime?.toIso8601String();
    data['supervisorEndTime'] = supervisorEndTime?.toIso8601String();
    data['technicianStartTime'] = technicianStartTime?.toIso8601String();
    data['technicianEndTime'] = technicianEndTime?.toIso8601String();
    data['machineImage'] = machineImage;
    data['uploadOfPictureBeforeRepair'] = uploadOfPictureBeforeRepair;
    data['uploadOfPictureAfterRepair'] = uploadOfPictureAfterRepair;
    data['comments'] = comments;
    data['technicianComments'] = technicianComments;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt.toIso8601String();
    data['updatedAt'] = updatedAt.toIso8601String();
    return data;
  }

  @override
  String toString() =>
      '{"_id": "$id", "vendingController": "$vendingController", "checklistResponse": "$checklistResponse", "assignedSupervisor": "$assignedSupervisor", "assignedTechnician": "$assignedTechnician", "status": "$status", "startTime": "$startTime", "endTime": "$endTime", "machineId": "$machineId"}';
}
