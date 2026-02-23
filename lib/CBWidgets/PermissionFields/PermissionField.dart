import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../PermissionServices/PermissionService.dart';
 
 
part 'PermissionField.g.dart';
 
@HiveType(typeId: 41)

class PermissionField {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final PermissionService? servicePermissionId;
	@HiveField(2)
	 
	final String? fieldName;
	@HiveField(3)
	 
	final bool? onCreate;
	@HiveField(4)
	 
	final bool? onUpdate;
	@HiveField(5)
	 
	final bool? onDetail;
	@HiveField(6)
	 
	final bool? onTable;

  PermissionField({
    this.id,
		this.servicePermissionId,
		this.fieldName,
		this.onCreate,
		this.onUpdate,
		this.onDetail,
		this.onTable
  });

  factory PermissionField.fromJson(Map<String, dynamic> map) {
    return PermissionField(
      id: map['_id'] as String?,
			servicePermissionId : map['servicePermissionId'] != null ? PermissionService.fromJson(map['servicePermissionId']) : null,
			fieldName : map['fieldName'] as String?,
			onCreate : map['onCreate'] as bool,
			onUpdate : map['onUpdate'] as bool,
			onDetail : map['onDetail'] as bool,
			onTable : map['onTable'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"servicePermissionId" : servicePermissionId?.id.toString(),
			"onCreate" : onCreate,
			"onUpdate" : onUpdate,
			"onDetail" : onDetail,
			"onTable" : onTable
    };
}

  @override
  String toString() => 'PermissionField("_id" : $id,"servicePermissionId": $servicePermissionId.toString(),"fieldName": $fieldName.toString(),"onCreate": $onCreate,"onUpdate": $onUpdate,"onDetail": $onDetail,"onTable": $onTable)';
}