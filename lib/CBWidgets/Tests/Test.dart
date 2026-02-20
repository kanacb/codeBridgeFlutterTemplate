import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Test {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? stack;
	 
	@HiveField(2)
	final String? service;
	 
	@HiveField(3)
	final int? passed;
	 
	@HiveField(4)
	final int? failed;
	 
	@HiveField(5)
	final String? notes;
	 

  Test({
    this.id,
		this.stack,
		this.service,
		this.passed,
		this.failed,
		this.notes
  });

  factory Test.fromJson(Map<String, dynamic> map) {
    return Test(
      id: map['_id'] as String?,
			stack : map['stack'] as String?,
			service : map['service'] as String?,
			passed : map['passed'] as int,
			failed : map['failed'] as int,
			notes : map['notes'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"passed" : passed,
			"failed" : failed
    };
}

  @override
  String toString() => 'Test("_id" : $id,"stack": $stack,"service": $service,"passed": $passed,"failed": $failed,"notes": $notes)';
}