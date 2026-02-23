import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'Fcm.g.dart';
 
@HiveType(typeId: 28)

class Fcm {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String fcmId;
	@HiveField(2)
	 
	final String? device;
	@HiveField(3)
	 
	final bool? valid;

  Fcm({
    this.id,
		required this.fcmId,
		this.device,
		this.valid
  });

  factory Fcm.fromJson(Map<String, dynamic> map) {
    return Fcm(
      id: map['_id'] as String?,
			fcmId : map['fcmId'] as String,
			device : map['device'] as String?,
			valid : map['valid'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"valid" : valid
    };
}

  @override
  String toString() => 'Fcm("_id" : $id,"fcmId": $fcmId.toString(),"device": $device.toString(),"valid": $valid)';
}