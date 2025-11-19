class UploadFile {
  final String? id;
   String? userId;
  final String contentType;
  final String name;
  final String path;
  final String ext;
  final String url;
  final int lastModified;
  final DateTime lastModifiedDate;
  final String size;
  final String type;
  late final String? tableId;
  late final String? tableName;

  UploadFile(
      {this.id,
        this.userId,
      required this.contentType,
      required this.name,
      required this.path,
      required this.ext,
      required this.url,
      required this.lastModified,
      required this.lastModifiedDate,
      required this.size,
      required this.type,
      this.tableId,
      this.tableName});

  factory UploadFile.fromJson(Map<String, dynamic> map) {
    return UploadFile(
        id: map?['id'] ?? "",
        userId: map?['userId'] ?? "",
        contentType: map['contentType'],
        name: map['name'],
        path: map['path'],
        ext: map['ext'],
        url: map['url'],
        size: map['size'].cast<String>(),
        lastModified: int.parse(map['lastModified']),
        lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
        type: map['type'],
        tableId: map?['tableId'] ?? "",
        tableName: map?['tableName'] ?? "");
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['id'] = id ?? "";
    data['userId'] = userId ?? "";
    data['type'] = type;
    data['name'] = name;
    data['path'] = path;
    data['ext'] = ext;
    data['url'] = url;
    data['size'] = size;
    data['lastModified'] = lastModified.toString();
    data['lastModifiedDate'] = lastModifiedDate.toString();
    data['tableId'] = tableId ?? "";
    data['tableName'] = tableName ?? "";
    return data;
  }

  @override
  String toString() =>
      '{"id": "$id", "type" : "$type", "name" : "$name", "size" : "$size"   ,  "type" : "$type", "tableId" : "$tableId" , "tableName" : "$tableName" }';

  @override
  String toParams() =>
      """id=$id&userId=$userId&type=$type&name=$name&path=$path&ext=$ext&url=$url&size=$size&lastModified=$lastModified&lastModifiedDate=$lastModifiedDate&tableId=$tableId&tableName=$tableName""";
}
