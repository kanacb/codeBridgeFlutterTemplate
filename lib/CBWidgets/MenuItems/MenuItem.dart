import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../ProfileMenu/ProfileMenu.dart';
 
 
part 'MenuItem.g.dart';
 
@HiveType(typeId: 35)

class MenuItem {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final ProfileMenu userContext;
	@HiveField(2)
	 
	final String? menuItems;

  MenuItem({
    this.id,
		required this.userContext,
		this.menuItems
  });

  factory MenuItem.fromJson(Map<String, dynamic> map) {
    return MenuItem(
      id: map['_id'] as String?,
			userContext : ProfileMenu.fromJson(map['userContext']),
			menuItems : map['menuItems'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"userContext" : userContext.id.toString()
    };
}

  @override
  String toString() => 'MenuItem("_id" : $id,"userContext": $userContext.toString(),"menuItems": $menuItems.toString())';
}