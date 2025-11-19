import '../../../Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

part 'Inbox.g.dart';

@HiveType(typeId: 2)
class Inbox {
  @HiveField(0)
  final String id; // maps to "_id"

  @HiveField(1)
  final IdName? from;

  @HiveField(2)
  final IdName? toUser;

  @HiveField(3)
  final String subject;

  @HiveField(4)
  final String content;

  @HiveField(5)
  final String service;

  @HiveField(6)
  final bool read;

  @HiveField(7)
  final bool flagged;

  @HiveField(8)
  final DateTime sent;

  @HiveField(9)
  final String createdBy;

  @HiveField(10)
  final String updatedBy;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  Inbox({
    required this.id,
    required this.from,
    required this.toUser,
    required this.subject,
    required this.content,
    required this.service,
    required this.read,
    required this.flagged,
    required this.sent,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inbox.fromJson(Map<String, dynamic> json) {
    return Inbox(
      id: json['_id'] as String,
      from: json['from'] != null
          ? IdName.fromJson(json['from'] as Map<String, dynamic>)
          : null,
      toUser: json['toUser'] != null
          ? IdName.fromJson(json['toUser'] as Map<String, dynamic>)
          : null,
      subject: json['subject'] as String,
      content: json['content'] as String,
      service: json['service'] as String,
      read: json['read'] as bool,
      flagged: json['flagged'] as bool,
      sent: DateTime.parse(json['sent'] as String),
      // Handle createdBy and updatedBy as objects or strings:
      createdBy: json['createdBy'] is Map
          ? (json['createdBy'] as Map<String, dynamic>)['_id'] as String
          : json['createdBy'] as String,
      updatedBy: json['updatedBy'] is Map
          ? (json['updatedBy'] as Map<String, dynamic>)['_id'] as String
          : json['updatedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      // Convert nested objects using their toJson methods:
      'from': from?.toJson(),
      'toUser': toUser?.toJson(),
      'subject': subject,
      'content': content,
      'service': service,
      'read': read,
      'flagged': flagged,
      'sent': sent.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Inbox(id: $id, from: $from, toUser: $toUser, subject: $subject, content: $content, service: $service, read: $read, flagged: $flagged, sent: $sent, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
