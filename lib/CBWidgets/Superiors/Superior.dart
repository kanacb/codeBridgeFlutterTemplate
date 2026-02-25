import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Staffinfo/Staffinfo.dart';
import '../Staffinfo/Staffinfo.dart';
 
 
part 'Superior.g.dart';
 
@HiveType(typeId: 17)

class Superior {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Staffinfo? superior;
	@HiveField(2)
	 
	final Staffinfo? subordinate;

  Superior({
    this.id,
		this.superior,
		this.subordinate
  });

  factory Superior.fromJson(Map<String, dynamic> map) {
    return Superior(
      id: map['_id'] as String?,
			superior : map['superior'] != null ? Staffinfo.fromJson(map['superior']) : null,
			subordinate : map['subordinate'] != null ? Staffinfo.fromJson(map['subordinate']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"superior" : superior?.id.toString(),
			"subordinate" : subordinate?.id.toString()
    };
}

  @override
  String toString() => 'Superior("_id" : $id,"superior": $superior.toString(),"subordinate": $subordinate.toString())';
}