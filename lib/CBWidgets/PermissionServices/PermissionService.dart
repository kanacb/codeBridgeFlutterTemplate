import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
import '../Roles/Role.dart';
import '../Profiles/Profile.dart';
import '../Positions/Position.dart';
 
 
part 'PermissionService.g.dart';
 
@HiveType(typeId: 40)

class PermissionService {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String service;
	@HiveField(2)
	 
	final bool? create;
	@HiveField(3)
	 
	final bool? read;
	@HiveField(4)
	 
	final bool? update;
	@HiveField(5)
	 
	final bool? delete;
	@HiveField(6)
	 
	final bool? import;
	@HiveField(7)
	 
	final bool? export;
	@HiveField(8)
	 
	final bool? seeder;
	@HiveField(9)
	 
	final User? userId;
	@HiveField(10)
	 
	final Role? roleId;
	@HiveField(11)
	 
	final Profile? profile;
	@HiveField(12)
	 
	final Position? positionId;

  PermissionService({
    this.id,
		required this.service,
		this.create,
		this.read,
		this.update,
		this.delete,
		this.import,
		this.export,
		this.seeder,
		this.userId,
		this.roleId,
		this.profile,
		this.positionId
  });

  factory PermissionService.fromJson(Map<String, dynamic> map) {
    return PermissionService(
      id: map['_id'] as String?,
			service : map['service'] as String,
			create : map['create'] as bool,
			read : map['read'] as bool,
			update : map['update'] as bool,
			delete : map['delete'] as bool,
			import : map['import'] as bool,
			export : map['export'] as bool,
			seeder : map['seeder'] as bool,
			userId : map['userId'] != null ? User.fromJson(map['userId']) : null,
			roleId : map['roleId'] != null ? Role.fromJson(map['roleId']) : null,
			profile : map['profile'] != null ? Profile.fromJson(map['profile']) : null,
			positionId : map['positionId'] != null ? Position.fromJson(map['positionId']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"create" : create,
			"read" : read,
			"update" : update,
			"delete" : delete,
			"import" : import,
			"export" : export,
			"seeder" : seeder,
			"userId" : userId?.id.toString(),
			"roleId" : roleId?.id.toString(),
			"profile" : profile?.id.toString(),
			"positionId" : positionId?.id.toString()
    };
}

  @override
  String toString() => 'PermissionService("_id" : $id,"service": $service.toString(),"create": $create,"read": $read,"update": $update,"delete": $delete,"import": $import,"export": $export,"seeder": $seeder,"userId": $userId.toString(),"roleId": $roleId.toString(),"profile": $profile.toString(),"positionId": $positionId.toString())';
}