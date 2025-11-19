import 'package:hive/hive.dart';

part 'UsedPart.g.dart';

@HiveType(typeId: 52)
class UsedPart {
  @HiveField(0)
  String? partId;

  @HiveField(1)
  int? quantity;

  UsedPart({
    this.partId,
    this.quantity
  });

  factory UsedPart.fromJson(Map<String, dynamic> map) {
    return UsedPart(
      partId: map['partId'],
      quantity: map['quantity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'partId': partId,
      'quantity': quantity
    };
  }
}
