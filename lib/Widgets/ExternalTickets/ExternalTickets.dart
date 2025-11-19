import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'ExternalTickets.g.dart';

@HiveType(typeId: 7)
class ExternalTickets {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? machineId;
  @HiveField(2)
  final List<String>? checklistResponse;
  @HiveField(3)
  final IdName? externalUser;
  @HiveField(4)
  final IdName? assignedSupervisor;
  @HiveField(5)
  final IdName? assignedTechnician;
  @HiveField(6)
  final String? status;
  @HiveField(7)
  final DateTime? startTime;
  @HiveField(8)
  final DateTime? endTime;
  @HiveField(9)
  final DateTime? supervisorStartTime;
  @HiveField(10)
  final DateTime? supervisorEndTime;
  @HiveField(11)
  final DateTime? technicianStartTime;
  @HiveField(12)
  final DateTime? technicianEndTime;
  @HiveField(13)
  final List<String>? machineImage;
  @HiveField(14)
  final List<String>? uploadOfPictureBeforeRepair;
  @HiveField(15)
  final List<String>? uploadOfPictureAfterRepair;
  @HiveField(16)
  final String? openingRemarks;
  @HiveField(17)
  final String? closingRemarks;
  @HiveField(18)
  IdName? createdBy;
  @HiveField(19)
  IdName? updatedBy;
  @HiveField(20)
  final DateTime? createdAt;
  @HiveField(21)
  final DateTime? updatedAt;


  ExternalTickets({
    this.id,
    this.machineId,
    this.checklistResponse,
    this.externalUser,
    this.assignedSupervisor,
    this.assignedTechnician,
    this.status,
    this.startTime,
    this.endTime,
    this.supervisorStartTime,
    this.supervisorEndTime,
    this.technicianStartTime,
    this.technicianEndTime,
    this.machineImage,
    this.uploadOfPictureBeforeRepair,
    this.uploadOfPictureAfterRepair,
    this.openingRemarks,
    this.closingRemarks,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ExternalTickets.fromJson(Map<String, dynamic> map) {
    return ExternalTickets(
      id:
          map['_id'] as String?,
      machineId:
          map['machineId'] as String?,
      checklistResponse:
          map['checklistResponse'].cast<String>(),
      externalUser:
          map['externalUser'] == null ? null : IdName.fromJson(map['externalUser']),
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
      machineImage:
          (map['machineImage'] as List?)?.cast<String>(),
      uploadOfPictureBeforeRepair:
          (map['uploadOfPictureBeforeRepair'] as List?)?.cast<String>(),
      uploadOfPictureAfterRepair:
          (map['uploadOfPictureAfterRepair'] as List?)?.cast<String>(),
      openingRemarks:
          map['openingRemarks'] as String?,
      closingRemarks:
          map['closingRemarks'] as String?,
      createdBy:
          map['createdBy'] == null ? null : IdName.fromJson(map['createdBy']),
      updatedBy:
          map['updatedBy'] == null ? null : IdName.fromJson(map['updatedBy']),
      createdAt:
          map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] == null ? null : DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checklistResponse'] = checklistResponse;
    data['machineId'] = machineId;
    data['externalUser'] = externalUser;
    data['assignedSupervisor'] = assignedSupervisor;
    data['assignedTechnician'] = assignedTechnician;
    data['status'] = status;
    data['startTime'] = startTime?.toIso8601String();
    data['endTime'] = endTime?.toIso8601String();
    data['supervisorStartTime'] = supervisorStartTime?.toIso8601String();
    data['supervisorEndTime'] = supervisorEndTime?.toIso8601String();
    data['technicianStartTime'] = technicianStartTime?.toIso8601String();
    data['technicianEndTime'] = technicianEndTime?.toIso8601String();
    data['machineImage'] = machineImage;
    data['uploadOfPictureBeforeRepair'] = uploadOfPictureBeforeRepair;
    data['uploadOfPictureAfterRepair'] = uploadOfPictureAfterRepair;
    data['openingRemarks'] = openingRemarks;
    data['closingRemarks'] = closingRemarks;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }

  @override
  String toString() =>
      '{"_id": "$id",  "machineId": "$machineId", "externalUser": "$externalUser", "checklistResponse": "$checklistResponse", "assignedSupervisor": "$assignedSupervisor", "assignedTechnician": "$assignedTechnician", "status": "$status", "startTime": "$startTime", "endTime": "$endTime",}';
}
