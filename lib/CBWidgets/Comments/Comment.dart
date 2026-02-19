import 'package:hive/hive.dart';

part 'Comment.g.dart';

@HiveType(typeId: 3)
class Comment {
  @HiveField(0)
  late final String? id;

  @HiveField(1)
  late final String text;

  @HiveField(2)
  late final String? recordId;

  @HiveField(3)
  late final bool? resolved;

  @HiveField(4)
  late final String? createdBy;

  @HiveField(5)
  late final String? updatedBy;

  @HiveField(6)
  late final DateTime? createdAt;

  @HiveField(7)
  late final DateTime? updatedAt;

  Comment({
     this.id,
    required this.text,
     this.recordId,
     this.resolved,
     this.createdBy,
     this.updatedBy,
     this.createdAt,
     this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
        id: map["_id"],
        text: map["text"],
        recordId: map["recordId"],
        resolved: map["resolved"],
        createdBy: map['createdBy'],
        updatedBy: map['updatedBy'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data['text'] = text;
    data['recordId'] = recordId;
    data['resolved'] = resolved;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() =>
      '{"id": "$id", "text" : "$text", "recordId" : $recordId, "resolved" : "$resolved.toString()", "createdAt" : "$createdAt", "updateAt" : "$updatedAt"}';

}
