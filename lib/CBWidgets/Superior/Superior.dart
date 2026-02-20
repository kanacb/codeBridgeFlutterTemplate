import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Superior {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? superior;
	 
	@HiveField(2)
	final String? subordinate;
	 

  Superior({
    this.id,
		this.superior,
		this.subordinate
  });

  factory Superior.fromJson(Map<String, dynamic> map) {
    return Superior(
      id: map['_id'] as String?,
			superior : map['superior'] as String?,
			subordinate : map['subordinate'] as String?
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