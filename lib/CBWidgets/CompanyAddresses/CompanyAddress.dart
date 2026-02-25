import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Companies/Company.dart';
 
 
part 'CompanyAddress.g.dart';
 
@HiveType(typeId: 12)

class CompanyAddress {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Company? company;
	@HiveField(2)
	 
	final String? street1;
	@HiveField(3)
	 
	final String? street2;
	@HiveField(4)
	 
	final String? poscode;
	@HiveField(5)
	 
	final String? city;
	@HiveField(6)
	 
	final String? state;
	@HiveField(7)
	 
	final String? province;
	@HiveField(8)
	 
	final String? country;
	@HiveField(9)
	 
	final bool? isDefault;

  CompanyAddress({
    this.id,
		this.company,
		this.street1,
		this.street2,
		this.poscode,
		this.city,
		this.state,
		this.province,
		this.country,
		this.isDefault
  });

  factory CompanyAddress.fromJson(Map<String, dynamic> map) {
    return CompanyAddress(
      id: map['_id'] as String?,
			company : map['company'] != null ? Company.fromJson(map['company']) : null,
			street1 : map['street1'] as String?,
			street2 : map['street2'] as String?,
			poscode : map['poscode'] as String?,
			city : map['city'] as String?,
			state : map['state'] as String?,
			province : map['province'] as String?,
			country : map['country'] as String?,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"company" : company?.id.toString(),
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'CompanyAddress("_id" : $id,"company": $company.toString(),"street1": $street1.toString(),"street2": $street2.toString(),"poscode": $poscode.toString(),"city": $city.toString(),"state": $state.toString(),"province": $province.toString(),"country": $country.toString(),"isDefault": $isDefault)';
}