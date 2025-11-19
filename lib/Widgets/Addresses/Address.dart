class Address {
  String sId;
  String street1;
  String street2;
  String poscode;

  Address({required this.sId, required this.street1, required this.street2, required this.poscode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(sId: json['_id'], street1: json['Street1'], street2: json['Street2'], poscode: json['Poscode']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['Street1'] = street1;
    data['Street2'] = street2;
    data['Poscode'] = poscode;
    return data;
  }
}