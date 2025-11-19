
class ErrorCode409 {
  String? name;
  String? message;
  int? code;
  String? className;

  ErrorCode409(
      {this.name, this.message, this.code, this.className});

  ErrorCode409.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    message = json['message'];
    code = json['code'];
    className = json['className'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['message'] = message;
    data['code'] = code;
    data['className'] = className;
    return data;
  }
}
