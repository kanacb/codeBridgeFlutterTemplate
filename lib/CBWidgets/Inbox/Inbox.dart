import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
import '../Users/User.dart';
 
 
part 'Inbox.g.dart';
 
@HiveType(typeId: 43)

class Inbox {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final User? from;
	@HiveField(2)
	 
	final User? toUser;
	@HiveField(3)
	 
	final String? subject;
	@HiveField(4)
	 
	final String? content;
	@HiveField(5)
	 
	final String? service;
	@HiveField(6)
	 
	final bool? read;
	@HiveField(7)
	 
	final bool? flagged;
	@HiveField(8)
	 
	final bool? sent;
	@HiveField(9)
	 
	final String? links;

  Inbox({
    this.id,
		this.from,
		this.toUser,
		this.subject,
		this.content,
		this.service,
		this.read,
		this.flagged,
		this.sent,
		this.links
  });

  factory Inbox.fromJson(Map<String, dynamic> map) {
    return Inbox(
      id: map['_id'] as String?,
			from : map['from'] != null ? User.fromJson(map['from']) : null,
			toUser : map['toUser'] != null ? User.fromJson(map['toUser']) : null,
			subject : map['subject'] as String?,
			content : map['content'] as String?,
			service : map['service'] as String?,
			read : map['read'] as bool,
			flagged : map['flagged'] as bool,
			sent : map['sent'] as bool,
			links : map['links'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"from" : from?.id.toString(),
			"toUser" : toUser?.id.toString(),
			"read" : read,
			"flagged" : flagged,
			"sent" : sent
    };
}

  @override
  String toString() => 'Inbox("_id" : $id,"from": $from.toString(),"toUser": $toUser.toString(),"subject": $subject.toString(),"content": $content.toString(),"service": $service.toString(),"read": $read,"flagged": $flagged,"sent": $sent,"links": $links.toString())';
}