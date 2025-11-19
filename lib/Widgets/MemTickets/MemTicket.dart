import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
import 'UsedPart.dart';

part 'MemTicket.g.dart';

@HiveType(typeId: 51) // Unique typeId for this Hive model
class MemTicket {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? machineId;

  @HiveField(2)
  final List<String>? checklistResponse;

  @HiveField(3)
  final IdName? salesman;

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
  List<UsedPart>? usedParts;

  @HiveField(14)
  final String? salesmanComment;

  @HiveField(15)
  final String? technicianInitialComment;

  @HiveField(16)
  final String? technicianCloseComment;

  @HiveField(17)
  final String? openingRemarks;

  @HiveField(18)
  final String? closingRemarks;

  @HiveField(19)
  final List<String>? machineImage;

  @HiveField(20)
  final List<String>? uploadOfPictureBeforeRepair;

  @HiveField(21)
  final List<String>? uploadOfPictureAfterRepair;

  @HiveField(22)
  final IdName? createdBy;

  @HiveField(23)
  final IdName? updatedBy;

  @HiveField(24)
  final DateTime? createdAt;

  @HiveField(25)
  final DateTime? updatedAt;

  MemTicket({
    this.id,
    this.machineId,
    this.checklistResponse,
    this.salesman,
    this.assignedSupervisor,
    this.assignedTechnician,
    this.status,
    this.startTime,
    this.endTime,
    this.supervisorStartTime,
    this.supervisorEndTime,
    this.technicianStartTime,
    this.technicianEndTime,
    this.usedParts,
    this.salesmanComment,
    this.technicianInitialComment,
    this.technicianCloseComment,
    this.openingRemarks,
    this.closingRemarks,
    this.machineImage,
    this.uploadOfPictureBeforeRepair,
    this.uploadOfPictureAfterRepair,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an MemTicket instance
  factory MemTicket.fromJson(Map<String, dynamic> map) {
    return MemTicket(
      id:
          map['_id'] as String?,
      machineId:
          map['machineId'] as String?,
      checklistResponse:
          map['checklistResponse'].cast<String>(),
      salesman:
          map["salesman"] == null ? null : IdName.fromJson(map['salesman']),
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
      usedParts:
          (map['usedParts'] as List?)
              ?.map((e) => UsedPart.fromJson(e))
              .toList(),
      salesmanComment:
          map['salesmanComment'] as String?,
      technicianInitialComment:
          map['technicianInitialComment'] as String?,
      technicianCloseComment:
          map['technicianCloseComment'] as String?,
      openingRemarks:
          map['openingRemarks'] as String?,
      closingRemarks:
          map['closingRemarks'] as String?,
      machineImage:
          (map['machineImage'] as List?)?.cast<String>(),
      uploadOfPictureBeforeRepair:
          (map['uploadOfPictureBeforeRepair'] as List?)?.cast<String>(),
      uploadOfPictureAfterRepair:
          (map['uploadOfPictureAfterRepair'] as List?)?.cast<String>(),
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

  // Converts the MemTicket instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'machineId': machineId,
      'checklistResponse': checklistResponse,
      'salesman': salesman,
      'assignedSupervisor': assignedSupervisor,
      'assignedTechnician': assignedTechnician,
      'status': status,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'supervisorStartTime': supervisorStartTime?.toIso8601String(),
      'supervisorEndTime': supervisorEndTime?.toIso8601String(),
      'technicianStartTime': technicianStartTime?.toIso8601String(),
      'technicianEndTime': technicianEndTime?.toIso8601String(),
      'usedParts': usedParts?.map((e) => e.toJson()).toList(),
      'salesmanComment': salesmanComment,
      'technicianInitialComment': technicianInitialComment,
      'technicianCloseComment': technicianCloseComment,
      'openingRemarks': openingRemarks,
      'closingRemarks': closingRemarks,
      'machineImage': machineImage,
      'uploadOfPictureBeforeRepair': uploadOfPictureBeforeRepair,
      'uploadOfPictureAfterRepair': uploadOfPictureAfterRepair,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      '_id': id,
      'machineId': machineId,
      'checklistResponse': checklistResponse,
      'salesman': salesman,
      'assignedSupervisor': assignedSupervisor,
      'assignedTechnician': assignedTechnician,
      'status': status,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'supervisorStartTime': supervisorStartTime?.toIso8601String(),
      'supervisorEndTime': supervisorEndTime?.toIso8601String(),
      'technicianStartTime': technicianStartTime?.toIso8601String(),
      'technicianEndTime': technicianEndTime?.toIso8601String(),
      'usedParts': usedParts?.map((e) => e.toJson()).toList(),
      'salesmanComment': salesmanComment,
      'technicianInitialComment': technicianInitialComment,
      'technicianCloseComment': technicianCloseComment,
      'openingRemarks': openingRemarks,
      'closingRemarks': closingRemarks,
      'machineImage': machineImage,
      'uploadOfPictureBeforeRepair': uploadOfPictureBeforeRepair,
      'uploadOfPictureAfterRepair': uploadOfPictureAfterRepair,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  MemTicket: {
    "id": "$id",
    "machineId": "$machineId",
    "checklistResponse": "$checklistResponse",
    "salesman": "$salesman",
    "assignedSupervisor": "$assignedSupervisor",
    "assignedTechnician": "$assignedTechnician",
    "status": "$status",
    "startTime": "$startTime",
    "endTime": "$endTime",
    "supervisorStartTime": "$supervisorStartTime",
    "supervisorEndTime": "$supervisorEndTime",
    "technicianStartTime": "$technicianStartTime",
    "technicianEndTime": "$technicianEndTime",
    "usedParts": "$usedParts",
    "salesmanComment": "$salesmanComment",
    "technicianInitialComment": "$technicianInitialComment",
    "technicianCloseComment": "$technicianCloseComment",
    "openingRemarks": "$openingRemarks",
    "closingRemarks": "$closingRemarks",
    "uploadOfPictureBeforeRepair": $machineImage,
    "machineImage": $uploadOfPictureBeforeRepair,
    "uploadOfPictureAfterRepair": $uploadOfPictureAfterRepair,
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}

