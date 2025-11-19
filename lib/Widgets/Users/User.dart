import 'dart:convert';

import 'package:hive/hive.dart';
//  dart run build_runner build --delete-conflicting-outputs
part 'User.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  late final String? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  late final String? password;
  @HiveField(4)
  late final bool? status;
  @HiveField(5)
  late final bool? rememberToken;
  @HiveField(6)
  late final bool? isEmailVerified;
  @HiveField(7)
  // late final DateTime? emailVerifiedAt;
  late final bool? emailVerifiedAt;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final DateTime updatedAt;

  User(
      {this.id,
      required this.name,
      required this.email,
      this.password,
      this.isEmailVerified,
      this.status,
      this.rememberToken,
      this.emailVerifiedAt,
      required this.createdAt,
      required this.updatedAt});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['_id'].toString(),
        name: map['name'] ?? "",
        email: map['email'] ?? "",
        password: map['password'] ?? "",
        isEmailVerified: map['is_email_verified'] ?? false,
        status: map['status'] ?? false,
        rememberToken: map['remember_token'] ?? false,
        // emailVerifiedAt: map['email_verified_at'] == null
        //     ? null
        //     : DateTime.parse(map['email_verified_at']),
        emailVerifiedAt: map['email_verified_at'] ?? false,
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id != "null") data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['is_email_verified'] = isEmailVerified;
    data['status'] = status;
    data['remember_token'] = rememberToken;
    data['email_verified_at'] = emailVerifiedAt.toString();
    data['createdAt'] = createdAt.toString();
    data['updatedAt'] = updatedAt.toString();
    return data;
  }

  @override
  String toString() =>
      '{"id": "$id", "name" : "$name", "email" : "$email","status" : "$status", isEmailVerified : "$isEmailVerified", "emailVerifiedAt" : $emailVerifiedAt , "createdAt" : "$createdAt", "updateAt" : "$updatedAt"}';
}
