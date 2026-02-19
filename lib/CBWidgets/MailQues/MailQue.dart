class MailQue {
  late final String id;
  late final String? name;
  late final String? type;
  late final String? from;
  late final List<String>? recipients;
  late final bool? status;
  late final Data? data;
  late final String? subject;
  late final String? templateId;

  MailQue(
      {this.name,
      this.type,
      this.from,
      this.recipients,
      this.status,
      this.data,
      this.subject,
      this.templateId});

  MailQue.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    from = json['from'];
    recipients = json['recipients'].cast<String>();
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    subject = json['subject'];
    templateId = json['templateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['from'] = from;
    data['recipients'] = recipients;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['subject'] = subject;
    data['templateId'] = templateId;
    return data;
  }
}

class Data {
  String? name;
  String? code;

  Data({this.name, this.code});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}
