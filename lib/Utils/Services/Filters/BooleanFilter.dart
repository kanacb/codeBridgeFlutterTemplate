import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../PageUtils.dart';
import '../../Services/Schema.dart';

class BooleanFilter extends StatefulWidget {
  const BooleanFilter({super.key, required this.schema});
  final Schema? schema;

  @override
  State<BooleanFilter> createState() => _BooleanFilterState();
}

class _BooleanFilterState extends State<BooleanFilter> {
  String? field;
  String? ops;
  Utils utils = Utils();
  List<String>? fields;

  List<String> stringOperators = [
    "is null",
    "is true",
    "is false"
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
