import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

part 'JobStation.g.dart';

@HiveType(typeId: 41)
class JobStation {
  @HiveField(0)
  String? name;

  @HiveField(1)
  IdName? technicianId;

  JobStation({this.name, this.technicianId});

  factory JobStation.fromJson(Map<String, dynamic> map) {
    return JobStation()
      ..name = map['name']
      ..technicianId = map['technicianId'] == null
          ? null
          : IdName.fromJson(map['technicianId']);
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'technicianId': technicianId};
  }
}
