class ErrorCode413 {
  String? error;
  String? maxAllowedSize;

  ErrorCode413({this.error, this.maxAllowedSize});

  ErrorCode413.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    maxAllowedSize = json['maxAllowedSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['maxAllowedSize'] = maxAllowedSize;
    return data;
  }
}
