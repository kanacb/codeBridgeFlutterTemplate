import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'Step.g.dart';
 
@HiveType(typeId: 22)

class Step {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? userGuideID;
	@HiveField(2)
	 
	final String? Steps;
	@HiveField(3)
	 
	final String? Description;

  Step({
    this.id,
		this.userGuideID,
		this.Steps,
		this.Description
  });

  factory Step.fromJson(Map<String, dynamic> map) {
    return Step(
      id: map['_id'] as String?,
			userGuideID : map['userGuideID'] as IdName?,
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
  String toString() => 'Step("_id" : $id,"userGuideID": $userGuideID,"Steps": $Steps,"Description": $Description)';
}