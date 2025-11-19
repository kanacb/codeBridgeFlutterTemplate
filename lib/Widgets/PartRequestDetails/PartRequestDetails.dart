import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'PartRequestDetails.g.dart';

@HiveType(typeId: 27) // Unique typeId for Hive storage
class PartRequestDetails {
  @HiveField(0)
  final String? id; // Unique identifier for the part request

  @HiveField(1)
  final String? partName; // Reference to the part name from parts master

  @HiveField(2)
  final int? quantity; // Quantity requested

  @HiveField(3)
  final String? status; // Status of the request

  @HiveField(4)
  final String? comment; // Additional comments

  @HiveField(5)
  final DateTime? requestedDate; // Date of request

  @HiveField(6)
  final String? jobId; // Reference to the job station ticket

  @HiveField(7)
  final IdName? technician; // Reference to the technician profile

  @HiveField(8)
  final bool? isUsed;

  @HiveField(9)
  final DateTime? approvedDate;

  @HiveField(10)
  final IdName? approvedBy;

  @HiveField(11)
  final String? warehouse;

  @HiveField(12)
  final IdName? createdBy; // ID of the user who created the record

  @HiveField(13)
  final IdName? updatedBy; // ID of the user who last updated the record

  @HiveField(14)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(15)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  PartRequestDetails({
    this.id,
    this.partName,
    this.quantity,
    this.status,
    this.comment,
    this.requestedDate,
    this.jobId,
    this.technician,
    this.isUsed,
    this.approvedDate,
    this.approvedBy,
    this.warehouse,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a PartRequestDetails instance
  factory PartRequestDetails.fromJson(Map<String, dynamic> map) {
    return PartRequestDetails(
      id: map['_id'] as String?,
      partName: map['partName'] as String?,
      quantity: map['quantity'] as int?,
      status: map['status'] as String?,
      comment: map['comment'] as String?,
      requestedDate: map['requestedDate'] != null
          ? DateTime.parse(map['requestedDate'])
          : null,
      jobId: map['jobId'] as String?,
      technician: map['technician'] != null ? IdName.fromJson(map['technician']) : null,
      isUsed: map['isUsed'] as bool?,
      approvedDate: map['approvedDate'] != null ? DateTime.parse(map['approvedDate']) : null,
      approvedBy: map['approvedBy'] != null ? IdName.fromJson(map['approvedBy']) : null,
      warehouse: map['warehouse'] as String?,
      createdBy: map['createdBy'] != null ? IdName.fromJson(map['createdBy']) : null,
      updatedBy: map['updatedBy'] != null ? IdName.fromJson(map['updatedBy']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the PartRequestDetails instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'partName': partName,
      'quantity': quantity,
      'status': status,
      'comment': comment,
      'requestedDate': requestedDate?.toIso8601String(),
      'jobId': jobId,
      'technician': technician,
      'isUsed': isUsed,
      'approvedDate': approvedDate,
      'approvedBy': approvedBy,
      'warehouse': warehouse,
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
    "partName": "$partName",
    "quantity": $quantity,
    "status": "$status",
    "comment": "$comment",
    "requestedDate": "$requestedDate",
    "jobId": "$jobId",
    "technician": "$technician",
    "isUsed": "$isUsed",
    "approvedDate": "$approvedDate",
    "approvedBy": "$approvedBy",
    "warehouse": "$warehouse",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
