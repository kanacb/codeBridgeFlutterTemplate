import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Services/Schema.dart';
import '../../PageUtils.dart';

class StringFilter extends StatefulWidget {
  const StringFilter({super.key, required this.schema});
  final Schema? schema;

  @override
  State<StringFilter> createState() => _StringFilterState();
}

class _StringFilterState extends State<StringFilter> {
  String? field;
  String? ops;
  Utils utils = Utils();
  List<String>? fields;

  List<String> stringOperators = [
    "is",
    "is not",
    "contains",
    "does not contain",
    "starts with",
    "ends with",
    "is empty",
    "is not empty"
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
