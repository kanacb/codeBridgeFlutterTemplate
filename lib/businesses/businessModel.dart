import 'package:vx_index/global.dart';

class Business {
  final String id;
  late final String name;
  late final String reg;
  late final String phone;
  late final String mobile;
  final String address1;
  final String address2;
  late final String city;
  late final String postalcode;
  late final String state;
  late final String country;
  final String businessType;
  final String createdAt;
  final String updatedAt;

  Business({
    required this.id,
    required this.name,
    required this.reg,
    required this.phone,
    required this.mobile,
    required this.address1,
    required this.address2,
    required this.city,
    required this.postalcode,
    required this.state,
    required this.country,
    required this.businessType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
        id: map['_id'] as String,
        name: map['name'] as String,
        reg: map['reg'] as String,
        phone: map['phone'] as String,
        mobile: map['mobile'] as String,
        address1: map['address1'] as String,
        address2: map['address2'] as String,
        city: map['city'] as String,
        postalcode: map['postalcode'] as String,
        state: map['state'] as String,
        country: map['country'] as String,
        businessType: map['businessType'] as String,
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String);
  }

  @override
  String toString() => 'User(name: $name, registration : $reg)';
}

enum BusinessType { BUYER, OWNER, SELLER }
