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
	 
	final String? street1;
	@HiveField(3)
	 
	final String? street2;
	@HiveField(4)
	 
	final String? postalCode;
	@HiveField(5)
	 
	final String? city;
	@HiveField(6)
	 
	final String? state;
	@HiveField(7)
	 
	final String? province;
	@HiveField(8)
	 
	final String? country;

  UserAddress({
    this.id,
		this.userId,
		this.street1,
		this.street2,
		this.postalCode,
		this.city,
		this.state,
		this.province,
		this.country
  });

  factory UserAddress.fromJson(Map<String, dynamic> map) {
    return UserAddress(
      id: map['_id'] as String?,
			userId : map['userId'] != null ? User.fromJson(map['userId']) : null,
			street1 : map['street1'] as String?,
			street2 : map['street2'] as String?,
			postalCode : map['postalCode'] as String?,
			city : map['city'] as String?,
			state : map['state'] as String?,
			province : map['province'] as String?,
			country : map['country'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"userId" : userId?.id.toString()
    };
}

  @override
  String toString() => 'UserAddress("_id" : $id,"userId": $userId.toString(),"street1": $street1.toString(),"street2": $street2.toString(),"postalCode": $postalCode.toString(),"city": $city.toString(),"state": $state.toString(),"province": $province.toString(),"country": $country.toString())';
}