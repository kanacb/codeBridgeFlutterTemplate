class ErrorCode408 {
  String? message;
  int? timeout;

  ErrorCode408({this.message, this.timeout});

  ErrorCode408.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    timeout = json['timeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['timeout'] = timeout;
    return data;
  }
}
