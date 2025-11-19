class ErrorCode414 {
  String? error;
  String? message;
  int? statusCode;

  ErrorCode414({this.error, this.message, this.statusCode});

  ErrorCode414.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}
