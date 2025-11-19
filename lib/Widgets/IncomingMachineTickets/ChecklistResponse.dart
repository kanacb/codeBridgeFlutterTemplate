import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'ChecklistResponse.g.dart';

@HiveType(typeId: 40)
class ChecklistResponse {
  @HiveField(0)
  IdName? checkListId;

  @HiveField(1)
  String? checkId;

  @HiveField(2)
  dynamic responseValue;

  ChecklistResponse({this.checkListId, this.checkId, this.responseValue});

  factory ChecklistResponse.fromJson(Map<String, dynamic> json) {
    return ChecklistResponse()
      ..checkListId = json['checkListId'] == null
          ? null
          : IdName.fromJson(json['checkListId'])
      ..checkId = json['checkId']
      ..responseValue = json['responseValue'];
  }

  Map<String, dynamic> toJson() {
    return {
      'checkListId': checkListId,
      'checkId': checkId,
      'responseValue': responseValue,
    };
  }
}

