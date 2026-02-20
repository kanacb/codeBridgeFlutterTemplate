import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'UserAddress.g.dart';
 
@HiveType(typeId: 12)

class UserAddress {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? userId;
	@HiveField(2)
	 
	final String? Street1;
	@HiveField(3)
	 
	final String? Street2;
	@HiveField(4)
	 
	final String? Poscode;
	@HiveField(5)
	 
	final String? City;
	@HiveField(6)
	 
	final String? State;
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
		this.State,
		this.Province,
		this.Country
  });

  factory UserAddress.fromJson(Map<String, dynamic> map) {
    return UserAddress(
      id: map['_id'] as String?,
			userId : map['userId'] as IdName?,
			Street1 : map['Street1'] as String?,
			Street2 : map['Street2'] as String?,
			Poscode : map['Poscode'] as String?,
			City : map['City'] as String?,
			State : map['State'] as String?,
			Province : map['Province'] as String?,
			Country : map['Country'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'UserAddress("_id" : $id,"userId": $userId,"Street1": $Street1,"Street2": $Street2,"Poscode": $Poscode,"City": $City,"State": $State,"Province": $Province,"Country": $Country)';
}