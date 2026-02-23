import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'FcmQue.g.dart';
 
@HiveType(typeId: 29)

class FcmQue {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? payload;

  FcmQue({
    this.id,
		this.payload
  });

  factory FcmQue.fromJson(Map<String, dynamic> map) {
    return FcmQue(
      id: map['_id'] as String?,
			payload : map['payload'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'FcmQue("_id" : $id,"payload": $payload.toString())';
}