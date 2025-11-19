class ErrorCode404 {
  String? message;
  String? resource;

  ErrorCode404({this.message, this.resource});

  ErrorCode404.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    resource = json['resource'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['resource'] = resource;
    return data;
  }
}
