import 'package:hive/hive.dart';

part 'UserInvite.g.dart';

@HiveType(typeId: 4)
class UserInvite {
  @HiveField(0)
  late final String? id;

  @HiveField(1)
  late final String emailToInvite;

  @HiveField(2)
  late final bool? status;

  @HiveField(3)
  late final int? code;

  @HiveField(4)
  late final String? position;

  @HiveField(5)
  late final String? role;

  @HiveField(6)
  late final int? sendMailCounter;

  @HiveField(7)
  late final DateTime? createdAt;

  @HiveField(8)
  late final DateTime? updatedAt;

  UserInvite({
    this.id,
    required this.emailToInvite,
    this.status,
    this.code,
    this.position,
    this.role,
    this.sendMailCounter,
    this.createdAt,
    this.updatedAt,
  });

  factory UserInvite.fromJson(Map<String, dynamic> map) {
    return UserInvite(
        id: map["_id"],
        emailToInvite: map["emailToInvite"],
        status: map["status"],
        code: map["code"],
        position: map['position'],
        role: map['role'],
        sendMailCounter: map['sendMailCounter'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data['emailToInvite'] = emailToInvite;
    data['status'] = status;
    data['code'] = code;
    data['position'] = position;
    data['role'] = role;
    data['sendMailCounter'] = sendMailCounter;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() =>
      '{"id": "$id", "emailToInvite" : "$emailToInvite", "code" : "$code", "status" : "$status.toString()", role : "$role",position : "$position", "createdAt" : "$createdAt", "updateAt" : "$updatedAt"}';
}
