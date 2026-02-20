import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'UserPhone.g.dart';
 
@HiveType(typeId: 15)

class UserPhone {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? userId;
	@HiveField(2)
	 
	final int? countryCode;
	@HiveField(3)
	 
	final int? operatorCode;
	@HiveField(4)
	 
	final int? number;
	@HiveField(5)
	 
	final String? type;
	@HiveField(6)
	 
	final bool? isDefault;

  UserPhone({
    this.id,
		this.userId,
		this.countryCode,
		this.operatorCode,
		this.number,
		this.type,
		this.isDefault
  });

  factory UserPhone.fromJson(Map<String, dynamic> map) {
    return UserPhone(
      id: map['_id'] as String?,
			userId : map['userId'] as IdName?,
			countryCode : map['countryCode'] as int,
			operatorCode : map['operatorCode'] as int,
			number : map['number'] as int,
			type : map['type'] as String?,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"countryCode" : countryCode,
			"operatorCode" : operatorCode,
			"number" : number,
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'UserPhone("_id" : $id,"userId": $userId,"countryCode": $countryCode,"operatorCode": $operatorCode,"number": $number,"type": $type,"isDefault": $isDefault)';
}