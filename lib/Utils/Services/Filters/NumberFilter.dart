import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Services/Schema.dart';
import '../../PageUtils.dart';

class NumberFilter extends StatefulWidget {
  const NumberFilter({super.key, required this.schema});
  final Schema? schema;

  @override
  State<NumberFilter> createState() => _NumberFilterState();
}

class _NumberFilterState extends State<NumberFilter> {
  String? field;
  String? ops;
  Utils utils = Utils();
  List<String>? fields;

  List<String> stringOperators = [
    "is null",
    "is equal",
    "is not equal",
    "is greater or equal to",
    "is greater than",
    "is less than or equal to",
    "is less",
    "is empty",
    "is in between"
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
