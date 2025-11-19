class ErrorCode400 {
  String? error;
  String? description;

  ErrorCode400({this.error, this.description});

  ErrorCode400.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['description'] = description;
    return data;
  }
}
