import 'package:aims/Widgets/JobStationQueues/JobStationInsideQueue.dart';
import 'package:hive/hive.dart';

import '../../Utils/Services/IdName.dart';

part 'JobStationQueue.g.dart';

@HiveType(typeId: 46) // Unique typeId for Hive storage
class JobStationQueue {
  @HiveField(0)
  final String? id; // Unique identifier for the job station

  @HiveField(1)
  final String? ticketId; // IncomingMachineTicket

  @HiveField(2)
  final String? machineId;

  @HiveField(3)
  final String? machineService;

  @HiveField(4)
  final List<JobStationInsideQueue>? jobStations;

  @HiveField(5)
  final int? priority;

  @HiveField(6)
  final String? errorMessage;

  @HiveField(7)
  final DateTime? startTime;

  @HiveField(8)
  final DateTime? endTime;

  @HiveField(9)
  final IdName? selectedUser; // Profile actually, not User

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  JobStationQueue({
    this.id,
    this.ticketId,
    this.machineId,
    this.machineService,
    this.jobStations,
    this.priority,
    this.errorMessage,
    this.startTime,
    this.endTime,
    this.selectedUser,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a JobStation instance
  factory JobStationQueue.fromJson(Map<String, dynamic> map) {
    return JobStationQueue(
      id: map['_id'] as String?,
      ticketId: map['ticketId'] as String?,
      machineId: map['machineId'] as String?,
      machineService: map['machineService'] as String?,
      jobStations:
          (map['jobStations'] as List?)
              ?.map((e) => JobStationInsideQueue.fromJson(e))
              .toList(),
      priority: map['priority'] as int?,
      errorMessage: map['errorMessage'] as String?,
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      selectedUser: map['selectedUser'] != null ? IdName.fromJson(map['selectedUser']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the JobStation instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'machineId': machineId,
      'machineService': machineService,
      'jobStations': jobStations?.map((e) => e.toJson()).toList(),
      'priority': priority,
      'errorMessage': errorMessage,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'selectedUser': selectedUser,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Override the toString method for better debug logging
  @override
  String toString() {
    return '''
    JobStationQueue {
      id: $id,
      ticketId: $ticketId,
      machineId: $machineId,
      machineService: $machineService,
      jobStations: $jobStations,
      priority: $priority,
      errorMessage: $errorMessage,
      startTime: $startTime,
      endTime: $endTime,
      selectedUser: $selectedUser,
      createdAt: $createdAt,
      updatedAt: $updatedAt,
    }
    ''';
  }
}
