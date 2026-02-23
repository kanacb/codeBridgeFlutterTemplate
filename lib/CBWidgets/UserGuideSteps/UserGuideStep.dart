import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../UserGuide/UserGuide.dart';
 
 
part 'UserGuideStep.g.dart';
 
@HiveType(typeId: 21)

class UserGuideStep {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final UserGuide? userGuideID;
	@HiveField(2)
	 
	final String Steps;
	@HiveField(3)
	 
	final String Description;

  UserGuideStep({
    this.id,
		this.userGuideID,
		required this.Steps,
		required this.Description
  });

  factory UserGuideStep.fromJson(Map<String, dynamic> map) {
    return UserGuideStep(
      id: map['_id'] as String?,
			userGuideID : map['userGuideID'] != null ? UserGuide.fromJson(map['userGuideID']) : null,
			Steps : map['Steps'] as String,
			Description : map['Description'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"userGuideID" : userGuideID?.id.toString()
    };
}

  @override
  String toString() => 'UserGuideStep("_id" : $id,"userGuideID": $userGuideID.toString(),"Steps": $Steps.toString(),"Description": $Description.toString())';
}