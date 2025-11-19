import 'package:hive/hive.dart';

import '../../Utils/Services/IdName.dart';

part 'IncomingMachineAbortHistory.g.dart';

@HiveType(typeId: 49) // Unique typeId for Hive storage
class IncomingMachineAbortHistory {
  @HiveField(0)
  final String? id; // Unique identifier for the job station

  @HiveField(1)
  final String? ticketId; // IncomingMachineTicket

  @HiveField(2)
  final IdName? abortedBy;

  @HiveField(3)
  final String? abortReason;

  @HiveField(4)
  final DateTime? abortedAt;

  @HiveField(5)
  final String? machineId;

  @HiveField(6)
  final String? status;

  @HiveField(7)
  final IdName? createdBy;

  @HiveField(8)
  final IdName? updatedBy;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  IncomingMachineAbortHistory({
    this.id,
    this.ticketId,
    this.abortedBy,
    this.abortReason,
    this.abortedAt,
    this.machineId,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a JobStation instance
  factory IncomingMachineAbortHistory.fromJson(Map<String, dynamic> map) {
    return IncomingMachineAbortHistory(
      id: map['_id'] as String?,
      ticketId: map['ticketId'] as String?,
      abortedBy: map['abortedBy'] != null ? IdName.fromJson(map['abortedBy']) : null,
      abortReason: map['abortReason'] as String?,
      abortedAt: map['abortedAt'] != null ? DateTime.parse(map['abortedAt']) : null,
      machineId: map['machineId'] as String?,
      status: map['status'] as String?,
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
      'abortedBy': abortedBy,
      'abortReason': abortReason,
      'abortedAt': abortedAt?.toIso8601String(),
      'machineId': machineId,
      'status': status,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Override the toString method for better debug logging
  @override
  String toString() {
    return '''
    IncomingMachineAbortHistory {
      id: $id,
      ticketId: $ticketId,
      abortedBy: $abortedBy,
      abortReason: $abortReason,
      abortedAt: $abortedAt,
      machineId: $machineId,
      status: $status,
      createdBy: $createdBy,
      updatedBy: $updatedBy,
      createdAt: $createdAt,
      updatedAt: $updatedAt,
    }
    ''';
  }
}
