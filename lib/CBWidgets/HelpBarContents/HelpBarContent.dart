import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'HelpBarContent.g.dart';
 
@HiveType(typeId: 31)

class HelpBarContent {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? serviceName;
	@HiveField(2)
	 
	final String content;

  HelpBarContent({
    this.id,
		this.serviceName,
		required this.content
  });

  factory HelpBarContent.fromJson(Map<String, dynamic> map) {
    return HelpBarContent(
      id: map['_id'] as String?,
			serviceName : map['serviceName'] as String?,
			content : map['content'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'HelpBarContent("_id" : $id,"serviceName": $serviceName.toString(),"content": $content.toString())';
}