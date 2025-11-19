class Schema {
  late String field;
  String? type;
  bool? required;
  bool? auto;
  bool? immutable;
  bool? unique;
  bool? lowercase;
  bool? uppercase;
  int? minLength;
  int? maxLength;
  bool? index;
  bool? trim;
  String? label;
  String? component;
  String? description;
  bool? autoComplete;
  bool? creatable;
  bool? editable;
  bool? display;
  bool? displayOnSingle;
  bool? displayOnEdit;
  bool? displayOnDataTable;
  String? refServiceName;
  String? refDatabaseName;
  String? relationshipType;
  List<String>? identifierFieldName;

  RegExp regex = RegExp(r"^isArray$");

  Schema(
      {required this.field,
      this.type,
      this.required,
      this.auto,
      this.immutable,
      this.unique,
      this.lowercase,
      this.uppercase,
      this.minLength,
      this.maxLength,
      this.index,
      this.trim,
      this.label,
      this.component,
      this.description,
      this.autoComplete,
      this.creatable,
      this.editable,
      this.display,
      this.displayOnEdit,
      this.displayOnSingle,
      this.displayOnDataTable,
      this.refServiceName,
      this.refDatabaseName,
      this.relationshipType,
      this.identifierFieldName});

  Schema.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    description = json['description'];
    type = json['description'] != null && regex.hasMatch(description!)
        ? json['type'][0]
        : json['type'];
    required = json['required'];
    auto = json['auto'];
    immutable = json["immutable"];
    unique = json['unique'];
    lowercase = json['lowercase'];
    uppercase = json['uppercase'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    index = json['index'];
    trim = json['trim'];

    if (json['comment'] != null) {
      List splitComponent = json['comment']?.split(',');
      label = splitComponent[0]?.trim() ?? json['field'];
      component =
          splitComponent.length >= 2 ? splitComponent[1]?.trim() ?? "p" : "";
      autoComplete = splitComponent.length >= 3
          ? splitComponent[2]?.trim().toLowerCase() == 'true'
          : false;
      creatable = splitComponent.length >= 4
          ? splitComponent[3]?.trim().toLowerCase() == 'true'
          : false;
      editable = splitComponent.length >= 5
          ? splitComponent[4]?.trim().toLowerCase() == 'true'
          : false;
      display = splitComponent.length >= 6
          ? splitComponent[5]?.trim().toLowerCase() == 'true'
          : false;
      displayOnEdit = splitComponent.length >= 7
          ? splitComponent[6]?.trim().toLowerCase() == 'true'
          : false;
      displayOnSingle = splitComponent.length >= 8
          ? splitComponent[7]?.trim().toLowerCase() == 'true'
          : false;
      displayOnDataTable = splitComponent.length >= 9
          ? splitComponent[8]?.trim().toLowerCase() == 'true'
          : false;
      refServiceName = splitComponent.length >= 10
          ? splitComponent[9]?.trim().toLowerCase()
          : "";
      refDatabaseName = splitComponent.length >= 11
          ? splitComponent[10]?.trim().toLowerCase()
          : "";
      relationshipType = splitComponent.length >= 12
          ? splitComponent[11]?.trim().toLowerCase()
          : "";
      identifierFieldName =
          splitComponent.length >= 13 ? splitComponent[12]?.split(':') : [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['type'] = type;
    data['required'] = required;
    data['auto'] = auto;
    data['immutable'] = immutable;
    data['unique'] = unique;
    data['lowercase'] = lowercase;
    data['uppercase'] = uppercase;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    data['index'] = index;
    data['trim'] = trim;
    data['description'] = description;
    data['comment'] = "";
    // "$label, $component, ${autoComplete?.toString()}, ${creatable?.toString()}, ${editable?.toString()}, ${display?.toString()}, ${displayOnEdit?.toString()}, ${displayOnSingle?.toString()}, ${displayOnDataTable?.toString()}";
    return data;
  }
}
