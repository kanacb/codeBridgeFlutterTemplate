import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'JobStationTicket.g.dart';

@HiveType(typeId: 18) // Unique typeId for Hive storage
class JobStationTicket {
  @HiveField(0)
  final String? id; // Unique identifier for the job station record

  @HiveField(1)
  final String? ticketId; // Related to incomingmachinetickets

  @HiveField(2)
  final String? jobStationId; // Identifier of the job station

  @HiveField(3)
  final IdName? supervisorId; // ID and Name of the assigned supervisor

  @HiveField(4)
  final IdName? technicianId; // ID and Name of the assigned technician

  @HiveField(5)
  final String? machineId; // ID of the vending machine

  @HiveField(6)
  final String? machineService; // ID of the vending machine

  @HiveField(7)
  final DateTime? startTime; // Job station start time

  @HiveField(8)
  final DateTime? endTime; // Job station end time (nullable)

  @HiveField(9)
  final String? status; // Current status of the job station (e.g., "Open", "Closed")

  @HiveField(10)
  final String? visibility; // visibility of the ticket

  @HiveField(11)
  final List<String>? uploadOfPictureBeforeRepair;

  @HiveField(12)
  final List<String>? uploadOfPictureAfterRepair;

  @HiveField(13)
  final String? incomingRemarks; // Remarks for the incoming job station (Before Repair)

  @HiveField(14)
  final String? jobCarriedOut; // Job Carried Out for the incoming job station (After Repair)

  @HiveField(15)
  final String? comments; // Comments/Remarks for the incoming job station (After Repair)

  @HiveField(16)
  final IdName? createdBy; // ID and Name of the user who created the record

  @HiveField(17)
  final IdName? updatedBy; // ID and Name of the user who last updated the record

  @HiveField(18)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(19)
  final DateTime? updatedAt; // Timestamp for when the record was last updated


  JobStationTicket({
    this.id,
    this.ticketId,
    required this.jobStationId,
    this.supervisorId,
    this.technicianId,
    this.machineId,
    this.machineService,
    this.startTime,
    this.endTime,
    this.status,
    required this.visibility,
    this.uploadOfPictureBeforeRepair,
    this.uploadOfPictureAfterRepair,
    this.incomingRemarks,
    this.jobCarriedOut,
    this.comments,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a JobStation instance
  factory JobStationTicket.fromJson(Map<String, dynamic> map) {
    return JobStationTicket(
      id: map['_id'] as String?,
      ticketId: map['ticketId'] as String?,
      jobStationId: map['jobStationId'] as String?,
      supervisorId: map['supervisorId'] != null ? IdName.fromJson(map['supervisorId']) : null,
      technicianId: map['technicianId'] != null ? IdName.fromJson(map['technicianId']) : null,
      machineId: map['machineId'] as String?,
      machineService: map['machineService'] as String?,
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      status: map['status'] as String?,
      visibility: map['visibility'] as String?,
      uploadOfPictureBeforeRepair: (map['uploadOfPictureBeforeRepair'] as List?)?.cast<String>(),
      uploadOfPictureAfterRepair: (map['uploadOfPictureAfterRepair'] as List?)?.cast<String>(),
      incomingRemarks: map['incomingRemarks'] as String?,
      jobCarriedOut: map['jobCarriedOut'] as String?,
      comments: map['comments'] as String?,
      createdBy: map['createdBy'] != null ? IdName.fromJson(map['createdBy']) : null,
      updatedBy: map['updatedBy'] != null ? IdName.fromJson(map['updatedBy']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the JobStation instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'jobStationId': jobStationId,
      'supervisorId': supervisorId,
      'technicianId': technicianId,
      'machineId': machineId,
      'machineService': machineService,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status,
      'visibility': visibility,
      'uploadOfPictureBeforeRepair': uploadOfPictureBeforeRepair,
      'uploadOfPictureAfterRepair': uploadOfPictureAfterRepair,
      'incomingRemarks': incomingRemarks,
      'jobCarriedOut': jobCarriedOut,
      'comments': comments,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  {
    "id": "$id",
    "ticketId": "$ticketId",
    "jobStationId": "$jobStationId",
    "supervisorId": "$supervisorId",
    "technicianId": "$technicianId",
    "machineId": "$machineId",
    "machineService": "$machineService",
    "startTime": "$startTime",
    "endTime": "$endTime",
    "status": "$status",
    "visibility": "$visibility",
    "uploadOfPictureBeforeRepair": "$uploadOfPictureBeforeRepair",
    "uploadOfPictureAfterRepair": "$uploadOfPictureAfterRepair",
    "incomingRemarks": "$incomingRemarks",
    "jobCarriedOut": "$jobCarriedOut",
    "comments": "$comments",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt",
  }''';
}
