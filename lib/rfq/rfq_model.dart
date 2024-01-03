class RFQ {
  String id = '';
  String businessId = '';
  String createdBy = '';
  String commodityId = '';
  String paymentTermsId = '';
  String deliveryMethodId = '';
  String expiration = '';
  String delivery = '';
  int? quantity = 0;
  String? description = '';
  bool? isExpired = false;
  bool? isClosed = false;
  String createdAt = '';
  String updatedAt = '';

  RFQ({
    required this.id,
    required this.businessId,
    required this.createdBy,
    required this.commodityId,
    required this.paymentTermsId,
    required this.deliveryMethodId,
    required this.expiration,
    required this.delivery,
    required this.quantity,
    required this.description,
    required this.isExpired,
    required this.isClosed,
    required this.createdAt,
    required this.updatedAt,
  });

  RFQ.fromMap(Map<String, dynamic> json) {
    id = json['_id'];
    businessId = json['businessId'];
    createdBy = json['createdBy'];
    commodityId = json['commodityId'];
    paymentTermsId = json['paymentTermsId'];
    deliveryMethodId = json['deliveryMethodId'];
    expiration = json['expiration'];
    delivery = json['delivery'];
    quantity = json['quantity'];
    description = json['description'];
    isExpired = json['isExpired'];
    isClosed = json['isClosed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['businessId'] = businessId;
    data['createdBy'] = createdBy;
    data['commodityId'] = commodityId;
    data['paymentTermsId'] = paymentTermsId;
    data['deliveryMethodId'] = deliveryMethodId;
    data['expiration'] = expiration;
    data['delivery'] = delivery;
    data['quantity'] = quantity;
    data['description'] = description;
    data['isExpired'] = isExpired;
    data['isClosed'] = isClosed;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
