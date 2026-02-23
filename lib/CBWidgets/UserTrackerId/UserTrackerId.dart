import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
 
 
part 'UserTrackerId.g.dart';
 
@HiveType(typeId: 39)

class UserTrackerId {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String pageName;
	@HiveField(2)
	 
	final String? trackerCode;
	@HiveField(3)
	 
	final String? userAgent;
	@HiveField(4)
	 
	final String? language;
	@HiveField(5)
	 
	final String? timeZone;
	@HiveField(6)
	 
	final String? cookeisEnabled;
	@HiveField(7)
	 
	final String? doNotTrack;
	@HiveField(8)
	 
	final String? hardConcurrency;
	@HiveField(9)
	 
	final String? marketCode;
	@HiveField(10)
	 
	final bool? isLoggedIn;
	@HiveField(11)
	 
	final User? userId;

  UserTrackerId({
    this.id,
		required this.pageName,
		this.trackerCode,
		this.userAgent,
		this.language,
		this.timeZone,
		this.cookeisEnabled,
		this.doNotTrack,
		this.hardConcurrency,
		this.marketCode,
		this.isLoggedIn,
		this.userId
  });

  factory UserTrackerId.fromJson(Map<String, dynamic> map) {
    return UserTrackerId(
      id: map['_id'] as String?,
			pageName : map['pageName'] as String,
			trackerCode : map['trackerCode'] as String?,
			userAgent : map['userAgent'] as String?,
			language : map['language'] as String?,
			timeZone : map['timeZone'] as String?,
			cookeisEnabled : map['cookeisEnabled'] as String?,
			doNotTrack : map['doNotTrack'] as String?,
			hardConcurrency : map['hardConcurrency'] as String?,
			marketCode : map['marketCode'] as String?,
			isLoggedIn : map['isLoggedIn'] as bool,
			userId : map['userId'] != null ? User.fromJson(map['userId']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"isLoggedIn" : isLoggedIn,
			"userId" : userId?.id.toString()
    };
}

  @override
  String toString() => 'UserTrackerId("_id" : $id,"pageName": $pageName.toString(),"trackerCode": $trackerCode.toString(),"userAgent": $userAgent.toString(),"language": $language.toString(),"timeZone": $timeZone.toString(),"cookeisEnabled": $cookeisEnabled.toString(),"doNotTrack": $doNotTrack.toString(),"hardConcurrency": $hardConcurrency.toString(),"marketCode": $marketCode.toString(),"isLoggedIn": $isLoggedIn,"userId": $userId.toString())';
}