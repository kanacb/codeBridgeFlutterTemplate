
class Currency {
  final String id;
  final String currency;
  final String code;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  Currency(
      {required this.id,
      required this.currency,
      required this.code,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
        id: map['_id'] as String,
        currency: map['name'] as String,
        code: map['description'] as String,
        createdBy: map['createdBy'] as String,
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String);
  }

  @override
  String toString() => 'Commodity(name: $currency, description : $code)';
}
