import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'DocumentStorage.g.dart';
 
@HiveType(typeId: 27)

class DocumentStorage {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String name;
	@HiveField(2)
	 
	final int? size;
	@HiveField(3)
	 
	final String path;
	@HiveField(4)
	 
	final DateTime? lastModifiedDate;
	@HiveField(5)
	 
	final int? lastModified;
	@HiveField(6)
	 
	final String eTag;
	@HiveField(7)
	 
	final String versionId;
	@HiveField(8)
	 
	final String url;
	@HiveField(9)
	 
	final String? tableId;
	@HiveField(10)
	 
	final String? tableName;

  DocumentStorage({
    this.id,
		required this.name,
		this.size,
		required this.path,
		this.lastModifiedDate,
		this.lastModified,
		required this.eTag,
		required this.versionId,
		required this.url,
		this.tableId,
		this.tableName
  });

  factory DocumentStorage.fromJson(Map<String, dynamic> map) {
    return DocumentStorage(
      id: map['_id'] as String?,
			name : map['name'] as String,
			size : map['size'] as int,
			path : map['path'] as String,
			lastModifiedDate : map['lastModifiedDate'] != null ? DateTime.parse(map['lastModifiedDate']) : null,
			lastModified : map['lastModified'] as int,
			eTag : map['eTag'] as String,
			versionId : map['versionId'] as String,
			url : map['url'] as String,
			tableId : map['tableId'] as String?,
			tableName : map['tableName'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"size" : size,
			'lastModifiedDate' : lastModifiedDate?.toIso8601String(),
			"lastModified" : lastModified
    };
}

  @override
  String toString() => 'DocumentStorage("_id" : $id,"name": $name.toString(),"size": $size,"path": $path.toString(),"lastModifiedDate": $lastModifiedDate?.toIso8601String()},"lastModified": $lastModified,"eTag": $eTag.toString(),"versionId": $versionId.toString(),"url": $url.toString(),"tableId": $tableId.toString(),"tableName": $tableName.toString())';
}