import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class UserAddresses {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? userId;
	 
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
	 

  UserAddresses({
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

  factory UserAddresses.fromJson(Map<String, dynamic> map) {
    return UserAddresses(
      id: map['_id'] as String?,
			userId : map['userId'] as String?,
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
  String toString() => 'UserAddresses("_id" : $id,"userId": $userId,"Street1": $Street1,"Street2": $Street2,"Poscode": $Poscode,"City": $City,"State": $State,"Province": $Province,"Country": $Country)';
}