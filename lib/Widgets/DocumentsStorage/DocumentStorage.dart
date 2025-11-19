import 'package:hive/hive.dart';

import '../Users/User.dart';

part 'DocumentStorage.g.dart';

@HiveType(typeId: 6)
class DocumentStorage {
  @HiveField(0)
  late final String? id;
  @HiveField(1)
  late final String? name;
  @HiveField(2)
  late final int? size;
  @HiveField(3)
  late final String? path;
  @HiveField(4)
  late final DateTime? lastModifiedDate;
  @HiveField(5)
  late final int? lastModified;
  @HiveField(6)
  late final String? eTag;
  @HiveField(7)
  late final String? versionId;
  @HiveField(8)
  late final String? url;
  @HiveField(9)
  late final String? tableId;
  @HiveField(10)
  late final String? tableName;
  @HiveField(11)
  late final User? createdBy; // doesnt seem to have this in dB
  @HiveField(12)
  late final User? updatedBy; // doesnt seem to have this in dB
  @HiveField(13)
  final DateTime createdAt;
  @HiveField(14)
  final DateTime updatedAt;

  DocumentStorage(
      {this.id,
      this.name,
      this.size,
      this.path,
      this.lastModified,
      this.lastModifiedDate,
      this.eTag,
      this.versionId,
      this.url,
      this.tableId,
      this.tableName,
      required this.createdBy,
      required this.updatedBy,
      required this.createdAt,
      required this.updatedAt});

  factory DocumentStorage.fromJson(Map<String, dynamic> map) {
    return DocumentStorage(
        id: map['_id'] as String?,
        name: map['name'],
        size: map['size'],
        path: map['path'],
        lastModified: map['lastModified'],
        lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
        eTag: map['eTag'],
        versionId: map['versionId'],
        url: map['url'],
        tableId: map['tableId'],
        tableName: map['tableName'],
        createdBy: map['createdBy'] == null ? null : User.fromJson(map['createdBy']),
        updatedBy: map['updatedBy'] == null ? null : User.fromJson(map['updatedBy']),
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['size'] = size;
    data['path'] = path;
    data['lastModified'] = lastModified;
    data['lastModifiedDate'] = lastModified;
    data['eTag'] = eTag;
    data['versionId'] = versionId;
    data['url'] = url;
    data['tableId'] = tableId;
    data['tableName'] = tableName;
    data['createdBy'] = createdBy?.toJson();
    data['updatedBy'] = updatedBy?.toJson();
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() =>
      '{"_id": "$id", "name" : "$name", "size" : $size, "path" : $path, "lastModified" : "$lastModified.toString()", "lastModifiedDate" : "$lastModifiedDate.toString()", "eTag" : "$eTag", "versionId" : "$versionId", "url" : "$url", "tableId" : "$tableId", "tableName" : "$tableName", "createdBy" : "${createdBy?.name}", "updatedBy" : "${updatedBy?.name}", "createdAt" : "$createdAt", "updateAt" : "$updatedAt"}';
}
