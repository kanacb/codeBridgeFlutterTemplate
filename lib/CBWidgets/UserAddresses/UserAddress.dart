import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
 
 
part 'UserAddress.g.dart';
 
@HiveType(typeId: 11)

class UserAddress {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final User? userId;
	@HiveField(2)
	 
	final String? Street1;
	@HiveField(3)
	 
	final String? Street2;
	@HiveField(4)
	 
	final String? Poscode;
	@HiveField(5)
	 
	final String? City;
	@HiveField(6)
	 
	final String? stateName;
	@HiveField(7)
	 
	final String? Province;
	@HiveField(8)
	 
	final String? Country;

  UserAddress({
    this.id,
		this.userId,
		this.Street1,
		this.Street2,
		this.Poscode,
		this.City,
		this.stateName,
		this.Province,
		this.Country
  });

  factory UserAddress.fromJson(Map<String, dynamic> map) {
    return UserAddress(
      id: map['_id'] as String?,
			userId : map['userId'] != null ? User.fromJson(map['userId']) : null,
			Street1 : map['Street1'] as String?,
			Street2 : map['Street2'] as String?,
			Poscode : map['Poscode'] as String?,
			City : map['City'] as String?,
			stateName : map['stateName'] as String?,
			Province : map['Province'] as String?,
			Country : map['Country'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"userId" : userId?.id.toString()
    };
}

  @override
  String toString() => 'UserAddress("_id" : $id,"userId": $userId.toString(),"Street1": $Street1.toString(),"Street2": $Street2.toString(),"Poscode": $Poscode.toString(),"City": $City.toString(),"stateName": $stateName.toString(),"Province": $Province.toString(),"Country": $Country.toString())';
}