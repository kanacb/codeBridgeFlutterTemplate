import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
import 'JobStation.dart';
import 'ChecklistResponse.dart';

part 'IncomingMachineTicket.g.dart';

@HiveType(typeId: 9) // Unique typeId for this Hive model
class IncomingMachineTicket {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? machineId;

  @HiveField(2)
  IdName? incomingMachineChecker;

  @HiveField(3)
  IdName? assignedSupervisor;

  @HiveField(4)
  List<JobStation>? selectedJobStations;

  @HiveField(5)
  DateTime? startTime;

  @HiveField(6)
  DateTime? endTime;

  @HiveField(7)
  List<ChecklistResponse>? vendingControllerChecklistResponse;

  @HiveField(8)
  String? status;

  @HiveField(9)
  int? selectedJobStationIndex;

  @HiveField(10)
  List<String>? machineImage; // Referenced by ID

  @HiveField(11)
  IdName? createdBy;

  @HiveField(12)
  IdName? updatedBy;

  @HiveField(13)
  final DateTime? createdAt; // Timestamp when the record was created

  @HiveField(14)
  final DateTime? updatedAt; // Timestamp when the record was last updated

  @HiveField(15)
  String? machineService;

  @HiveField(16)
  String? comments;

  IncomingMachineTicket({
    this.id,
    this.machineId,
    this.machineService,
    this.incomingMachineChecker,
    this.assignedSupervisor,
    this.selectedJobStations,
    this.startTime,
    this.endTime,
    this.vendingControllerChecklistResponse,
    this.status,
    this.selectedJobStationIndex = 0,
    this.machineImage,
    this.comments,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an IncomingMachineTicket instance
  factory IncomingMachineTicket.fromJson(Map<String, dynamic> map) {
    return IncomingMachineTicket(
      id:
          map['_id'] as String?,
      machineId:
          map['machineId'] as String?,
      machineService:
          map['machineService'] as String?,
      incomingMachineChecker:
          map["incomingMachineChecker"] == null ? null : IdName.fromJson(map['incomingMachineChecker']),
      assignedSupervisor:
          map['assignedSupervisor'] == null ? null : IdName.fromJson(map['assignedSupervisor']),
      selectedJobStations: (map['selectedJobStations'] as List?)
          ?.whereType<Map<String, dynamic>>() // ensure only properly formatted data is processed
          .map((e) => JobStation.fromJson(e))
          .toList(),
      startTime:
          map['startTime'] == null ? null : DateTime.parse(map['startTime']),
      endTime:
          map['endTime'] == null ? null : DateTime.parse(map['endTime']),
      vendingControllerChecklistResponse:
          (map['vendingControllerChecklistResponse'] as List?)
              ?.map((e) => ChecklistResponse.fromJson(e))
              .toList(),
      status:
          map['status'] as String?,
      selectedJobStationIndex:
          map['SelectedJobStationIndex'] as int? ?? 0,
      machineImage:
          (map['machineImage'] as List?)?.cast<String>(),
      comments:
          map['comments'] as String?,
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

  // Converts the IncomingMachineTicket instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'machineId': machineId,
      'machineService': machineService,
      'incomingMachineChecker': incomingMachineChecker,
      'assignedSupervisor': assignedSupervisor,
      'selectedJobStations':
          selectedJobStations?.map((e) => e.toJson()).toList(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'vendingControllerChecklistResponse':
          vendingControllerChecklistResponse?.map((e) => e.toJson()).toList(),
      'status': status,
      'SelectedJobStationIndex': selectedJobStationIndex,
      'machineImage': machineImage,
      'comments': comments,
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
      'machineService': machineService,
      'incomingMachineChecker': incomingMachineChecker,
      'assignedSupervisor': assignedSupervisor,
      'selectedJobStations':
      selectedJobStations?.map((e) => e.toJson()).toList(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'vendingControllerChecklistResponse':
      vendingControllerChecklistResponse?.map((e) => e.toJson()).toList(),
      'status': status,
      'SelectedJobStationIndex': selectedJobStationIndex,
      'machineImage': machineImage,
      'comments': comments,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  IncomingMachineTicket: {
    "id": "$id",
    "machineId": "$machineId",
    "machineService": "$machineService",
    "assignedSupervisor": "$assignedSupervisor",
    "selectedJobStations": $selectedJobStations,
    "startTime": "$startTime",
    "endTime": "$endTime",
    "vendingControllerChecklistResponse": $vendingControllerChecklistResponse,
    "status": "$status",
    "selectedJobStationIndex": $selectedJobStationIndex,
    "machineImage": $machineImage,
    "comments": $comments,
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}

