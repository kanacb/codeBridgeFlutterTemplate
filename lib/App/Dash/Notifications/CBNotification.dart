import 'package:hive/hive.dart';
import '../../../Utils/Services/IdName.dart';

part 'CBNotification.g.dart';

@HiveType(typeId: 5)
class CBNotification {
  @HiveField(0)
  late final String? id;

  @HiveField(1)
  late final IdName? toUser;

  @HiveField(2)
  late final String? content;

  @HiveField(3)
  late final String? path;

  @HiveField(4)
  late final String? method;

  @HiveField(5)
  late final String? data;

  @HiveField(6)
  late final String? recordId;

  @HiveField(7)
  late final bool? read;

  @HiveField(8)
  late final DateTime? sent;

  @HiveField(9)
  late final IdName? createdBy;

  @HiveField(10)
  late final IdName? updatedBy;

  @HiveField(11)
  late final DateTime? createdAt;

  @HiveField(12)
  late final DateTime? updatedAt;

  CBNotification({
    this.id,
    this.toUser,
    this.content,
    this.path,
    this.method,
    this.data,
    this.recordId,
    this.read,
    this.sent,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CBNotification.fromJson(Map<String, dynamic> map) {
    return CBNotification(
      id: map["_id"] as String?,
      toUser: map['toUser'] != null ? IdName.fromJson(map['toUser']) : null,
      content: map['content'] as String?,
      path: map['path'] as String?,
      method: map['method'] as String?,
      data: map['data'] as String?,
      recordId: map['recordId'] as String?,
      read: map['read'] as bool?,
      sent: map['sent'] != null ? DateTime.parse(map['sent']) : null,
      createdBy: map['createdBy'] != null ? IdName.fromJson(map['createdBy']) : null,
      updatedBy: map['updatedBy'] != null ? IdName.fromJson(map['updatedBy']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['toUser'] = toUser;
    map['content'] = content;
    map['path'] = path;
    map['method'] = method;
    map['data'] = data;
    map['recordId'] = recordId;
    map['read'] = read;
    map['sent'] = sent?.toIso8601String();
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['createdAt'] = createdAt?.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    return map;
  }

  @override
  String toString() =>
      'CBNotification(id: $id, toUser: ${toUser?.name}, content: $content, path: $path, method: $method, data: $data, recordId: $recordId, read: $read, sent: $sent, createdBy: ${createdBy?.name}, updatedBy: ${updatedBy?.name}, createdAt: $createdAt, updatedAt: $updatedAt)';
}
