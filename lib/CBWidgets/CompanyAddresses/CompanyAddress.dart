import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Companies/Company.dart';
 
 
part 'CompanyAddress.g.dart';
 
@HiveType(typeId: 12)

class CompanyAddress {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Company? companyId;
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
	@HiveField(9)
	 
	final bool? isDefault;

  CompanyAddress({
    this.id,
		this.companyId,
		this.Street1,
		this.Street2,
		this.Poscode,
		this.City,
		this.stateName,
		this.Province,
		this.Country,
		this.isDefault
  });

  factory CompanyAddress.fromJson(Map<String, dynamic> map) {
    return CompanyAddress(
      id: map['_id'] as String?,
			companyId : map['companyId'] != null ? Company.fromJson(map['companyId']) : null,
			Street1 : map['Street1'] as String?,
			Street2 : map['Street2'] as String?,
			Poscode : map['Poscode'] as String?,
			City : map['City'] as String?,
			stateName : map['stateName'] as String?,
			Province : map['Province'] as String?,
			Country : map['Country'] as String?,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"companyId" : companyId?.id.toString(),
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'CompanyAddress("_id" : $id,"companyId": $companyId.toString(),"Street1": $Street1.toString(),"Street2": $Street2.toString(),"Poscode": $Poscode.toString(),"City": $City.toString(),"stateName": $stateName.toString(),"Province": $Province.toString(),"Country": $Country.toString(),"isDefault": $isDefault)';
}