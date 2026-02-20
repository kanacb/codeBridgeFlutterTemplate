import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Steps {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? userGuideID;
	 
	@HiveField(2)
	final String? Steps;
	 
	@HiveField(3)
	final String? Description;
	 

  Steps({
    this.id,
		this.userGuideID,
		this.Steps,
		this.Description
  });

  factory Steps.fromJson(Map<String, dynamic> map) {
    return Steps(
      id: map['_id'] as String?,
			userGuideID : map['userGuideID'] as String?,
			Steps : map['Steps'] != null ? map['Steps'] as String : "",
			Description : map['Description'] != null ? map['Description'] as String : ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'Steps("_id" : $id,"userGuideID": $userGuideID,"Steps": $Steps,"Description": $Description)';
}