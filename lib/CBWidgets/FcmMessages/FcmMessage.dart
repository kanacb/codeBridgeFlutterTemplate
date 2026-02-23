import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
 
 
part 'FcmMessage.g.dart';
 
@HiveType(typeId: 30)

class FcmMessage {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? title;
	@HiveField(2)
	 
	final String body;
	@HiveField(3)
	 
	final List<User> recipients;
	@HiveField(4)
	 
	final String? image;
	@HiveField(5)
	 
	final String? payload;
	@HiveField(6)
	 
	final String? status;
	@HiveField(7)
	 
	final int? successCount;
	@HiveField(8)
	 
	final int? failureCount;

  FcmMessage({
    this.id,
		this.title,
		required this.body,
		required this.recipients,
		this.image,
		this.payload,
		this.status,
		this.successCount,
		this.failureCount
  });

  factory FcmMessage.fromJson(Map<String, dynamic> map) {
    return FcmMessage(
      id: map['_id'] as String?,
			title : map['title'] as String?,
			body : map['body'] as String,
			recipients : map['recipients'] != null ? (map['recipients'] as List).map((e) => User.fromJson(e)).toList() : [] ,
			image : map['image'] as String?,
			payload : map['payload'] as String?,
			status : map['status'] as String?,
			successCount : map['successCount'] as int,
			failureCount : map['failureCount'] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"recipients" : recipients.map((e) => e.toJson()).toList(),
			"successCount" : successCount,
			"failureCount" : failureCount
    };
}

  @override
  String toString() => 'FcmMessage("_id" : $id,"title": $title.toString(),"body": $body.toString(),"recipients": $recipients.toString(),"image": $image.toString(),"payload": $payload.toString(),"status": $status.toString(),"successCount": $successCount,"failureCount": $failureCount)';
}