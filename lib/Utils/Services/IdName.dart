import 'package:hive/hive.dart';

part 'IdName.g.dart';

@HiveType(typeId: 19)

class IdName {
  @HiveField(0)
  late String? sId;
  @HiveField(1)
  late String? name;

  IdName({this.sId, this.name});

  factory IdName.fromJson(Map<String, dynamic> json) {
    try {
      return IdName(sId: json['_id'] ?? "", name: json['name'] ?? "");
    } catch (e) {
      print(json);
      print("idName: $e");
      return IdName(sId: "sId", name: "name");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}