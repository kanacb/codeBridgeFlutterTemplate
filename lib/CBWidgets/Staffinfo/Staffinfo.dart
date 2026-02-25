import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'Staffinfo.g.dart';
 
@HiveType(typeId: 15)

class Staffinfo {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final int? empNo;
	@HiveField(2)
	 
	final String? name;
	@HiveField(3)
	 
	final String? nameNric;
	@HiveField(4)
	 
	final int? compCode;
	@HiveField(5)
	 
	final String? compName;
	@HiveField(6)
	 
	final String? deptCode;
	@HiveField(7)
	 
	final String? deptDesc;
	@HiveField(8)
	 
	final int? sectCode;
	@HiveField(9)
	 
	final String? sectDesc;
	@HiveField(10)
	 
	final String? designation;
	@HiveField(11)
	 
	final String? email;
	@HiveField(12)
	 
	final String? resign;
	@HiveField(13)
	 
	final String? supervisor;
	@HiveField(14)
	 
	final int? dateJoin;
	@HiveField(15)
	 
	final String? empGroup;
	@HiveField(16)
	 
	final String? empGradeCode;
	@HiveField(17)
	 
	final String? terminationDate;

  Staffinfo({
    this.id,
		this.empNo,
		this.name,
		this.nameNric,
		this.compCode,
		this.compName,
		this.deptCode,
		this.deptDesc,
		this.sectCode,
		this.sectDesc,
		this.designation,
		this.email,
		this.resign,
		this.supervisor,
		this.dateJoin,
		this.empGroup,
		this.empGradeCode,
		this.terminationDate
  });

  factory Staffinfo.fromJson(Map<String, dynamic> map) {
    return Staffinfo(
      id: map['_id'] as String?,
			empNo : map['empNo'] as int,
			name : map['name'] as String?,
			nameNric : map['nameNric'] as String?,
			compCode : map['compCode'] as int,
			compName : map['compName'] as String?,
			deptCode : map['deptCode'] as String?,
			deptDesc : map['deptDesc'] as String?,
			sectCode : map['sectCode'] as int,
			sectDesc : map['sectDesc'] as String?,
			designation : map['designation'] as String?,
			email : map['email'] as String?,
			resign : map['resign'] as String?,
			supervisor : map['supervisor'] as String?,
			dateJoin : map['dateJoin'] as int,
			empGroup : map['empGroup'] as String?,
			empGradeCode : map['empGradeCode'] as String?,
			terminationDate : map['terminationDate'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"empNo" : empNo,
			"compCode" : compCode,
			"sectCode" : sectCode,
			"dateJoin" : dateJoin
    };
}

  @override
  String toString() => 'Staffinfo("_id" : $id,"empNo": $empNo,"name": $name.toString(),"nameNric": $nameNric.toString(),"compCode": $compCode,"compName": $compName.toString(),"deptCode": $deptCode.toString(),"deptDesc": $deptDesc.toString(),"sectCode": $sectCode,"sectDesc": $sectDesc.toString(),"designation": $designation.toString(),"email": $email.toString(),"resign": $resign.toString(),"supervisor": $supervisor.toString(),"dateJoin": $dateJoin,"empGroup": $empGroup.toString(),"empGradeCode": $empGradeCode.toString(),"terminationDate": $terminationDate.toString())';
}