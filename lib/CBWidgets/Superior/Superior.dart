import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'Superior.g.dart';
 
@HiveType(typeId: 18)

class Superior {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? superior;
	@HiveField(2)
	 
	final IdName? subordinate;

  Superior({
    this.id,
		this.superior,
		this.subordinate
  });

  factory Superior.fromJson(Map<String, dynamic> map) {
    return Superior(
      id: map['_id'] as String?,
			superior : map['superior'] as IdName?,
			subordinate : map['subordinate'] as IdName?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'Superior("_id" : $id,"superior": $superior,"subordinate": $subordinate)';
}