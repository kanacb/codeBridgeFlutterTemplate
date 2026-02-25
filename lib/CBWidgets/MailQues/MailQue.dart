import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'MailQue.g.dart';
 
@HiveType(typeId: 33)

class MailQue {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;
	@HiveField(2)
	 
	final String? from;
	@HiveField(3)
	 
	final String? subject;
	@HiveField(4)
	 
	final String? recipients;
	@HiveField(5)
	 
	final String? content;
	@HiveField(6)
	 
	final String? payload;
	@HiveField(7)
	 
	final String? templateId;
	@HiveField(8)
	 
	final bool? status;
	@HiveField(9)
	 
	final int? jobId;
	@HiveField(10)
	 
	final DateTime? end;

  MailQue({
    this.id,
		this.name,
		this.from,
		this.subject,
		this.recipients,
		this.content,
		this.payload,
		this.templateId,
		this.status,
		this.jobId,
		this.end
  });

  factory MailQue.fromJson(Map<String, dynamic> map) {
    return MailQue(
      id: map['_id'] as String?,
			name : map['name'] as String?,
			from : map['from'] as String?,
			subject : map['subject'] as String?,
			recipients : map['recipients'] as String?,
			content : map['content'] as String?,
			payload : map['payload'] as String?,
			templateId : map['templateId'] as String?,
			status : map['status'] as bool,
			jobId : map['jobId'] as int,
			end : map['end'] != null ? DateTime.parse(map['end']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"status" : status,
			"jobId" : jobId,
			'end' : end?.toIso8601String()
    };
}

  @override
  String toString() => 'MailQue("_id" : $id,"name": $name.toString(),"from": $from.toString(),"subject": $subject.toString(),"recipients": $recipients.toString(),"content": $content.toString(),"payload": $payload.toString(),"templateId": $templateId.toString(),"status": $status,"jobId": $jobId,"end": $end?.toIso8601String()})';
}