import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'Phone.g.dart';

@HiveType(typeId: 57)
class Phone {
  @HiveField(0)
  final String sId;

  @HiveField(1)
  final String number;

  Phone({required this.sId, required this.number});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(sId: json['_id'], number: json['number']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['number'] = number;
    return data;
  }
}