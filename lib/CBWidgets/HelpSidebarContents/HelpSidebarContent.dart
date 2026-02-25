import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'HelpSidebarContent.g.dart';
 
@HiveType(typeId: 31)

class HelpSidebarContent {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? serviceName;
	@HiveField(2)
	 
	final String content;

  HelpSidebarContent({
    this.id,
		this.serviceName,
		required this.content
  });

  factory HelpSidebarContent.fromJson(Map<String, dynamic> map) {
    return HelpSidebarContent(
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
  String toString() => 'HelpSidebarContent("_id" : $id,"serviceName": $serviceName.toString(),"content": $content.toString())';
}