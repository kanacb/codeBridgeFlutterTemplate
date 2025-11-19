class ErrorCode403 {
  String? error;
  String? reason;

  ErrorCode403({this.error, this.reason});

  ErrorCode403.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['reason'] = reason;
    return data;
  }
}
