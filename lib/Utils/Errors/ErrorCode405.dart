class ErrorCode405 {
  String? error;
  String? allowedMethods;

  ErrorCode405({this.error, this.allowedMethods});

  ErrorCode405.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    allowedMethods = json['allowedMethods'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['allowedMethods'] = allowedMethods;
    return data;
  }
}
