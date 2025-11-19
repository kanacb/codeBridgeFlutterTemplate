import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Services/Schema.dart';
import '../../PageUtils.dart';

class DateFilter extends StatefulWidget {
  const DateFilter({super.key, required this.schema});
  final Schema? schema;

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  String? field;
  String? ops;
  Utils utils = Utils();
  List<String>? fields;

  List<String> stringOperators = [
    "is null",
    "is equal",
    "is not equal",
    "is later or equal to",
    "is later",
    "is earlier than or equal to",
    "is earlier",
    "is empty",
    "is in between",
    "is leap year",
    "is day of week",
    "is is months",
    "is year",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onChangeFields(String? value) {
    setState(() {
      field = value!;
      print(field);
    });
  }

  void onChangeOperator(String? value) {
    setState(() {
      ops = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text(
            widget.schema?.label ?? "",
          ),
          utils.buildDropdownButton(
              context, stringOperators!, onChangeOperator, ops),
        ],
      ),
    );
  }
}
