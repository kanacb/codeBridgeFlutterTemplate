import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '/Utils/Services/Filters/BooleanFilter.dart';
import '/Utils/Services/Filters/DateFilter.dart';
import '/Utils/Services/Filters/NumberFilter.dart';
import '/Utils/Globals.dart' as globals;
import '../PageUtils.dart';
import 'Filters/StringFilter.dart';
import 'Schema.dart';

class ServiceFilterByMenu extends StatefulWidget {
  const ServiceFilterByMenu({super.key, required this.show, this.response});
  final bool show;
  final List<Schema>? response;

  @override
  State<ServiceFilterByMenu> createState() => _ServiceFilterByMenu();
}

class _ServiceFilterByMenu extends State<ServiceFilterByMenu> {
  Logger logger = globals.logger;
  double _sheetPosition = 0;
  final double _dragSensitivity = 100;
  Utils utils = Utils();
  Schema? selected;
  dynamic? value;

  bool isBottom = false;
  bool isNumber = false;
  bool isString = false;
  bool isBool = false;
  bool isDate = false;
  late int change = 0;
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  late LabeledGlobalKey<FormState> key = LabeledGlobalKey<FormState>("Filter");

  onChanged(value) {
    value = value;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listofTiles = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 0),
            height: 10,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        "Filter by",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      isBottom
          ? Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    isString
                        ? StringFilter(
                            schema: selected,
                          )
                        : isNumber
                            ? NumberFilter(
                                schema: selected,
                              )
                            : isDate
                                ? DateFilter(
                                    schema: selected,
                                  )
                                : isBool
                                    ? BooleanFilter(
                                        schema: selected,
                                      )
                                    : SizedBox.shrink(),
                    isBottom
                        ? Column(
                            children: [
                              isBool
                                  ? Checkbox(
                                      value: value ?? false,
                                      onChanged: onChanged)
                                  : TextField(
                                      keyboardType: isString
                                          ? TextInputType.text
                                          : isDate
                                              ? TextInputType.datetime
                                              : TextInputType
                                                  .numberWithOptions(),
                                      decoration: InputDecoration(
                                          labelText: "Value",
                                          border: OutlineInputBorder()),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Add "resend code function" functionality
                                      setState(() {
                                        isBottom = false;
                                        isBool = false;
                                        isDate = false;
                                        isNumber = false;
                                        isString = false;
                                      });
                                    },
                                    child: const Text(
                                      "Add filter",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Add "resend code function" functionality
                                      setState(() {
                                        isBottom = false;
                                        isBool = false;
                                        isDate = false;
                                        isNumber = false;
                                        isString = false;
                                      });
                                    },
                                    child: const Text(
                                      "Clear filter",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : SizedBox.shrink()
                  ]),
            )
          : SizedBox.shrink()
    ];

    void listofFieldTiles() {
      for (var field in widget.response!) {
        if (field.field! == "id") continue;
        listofTiles.add(ListTile(
          trailing: utils.iconType(field.type?.toLowerCase()),
          title: Text(
            field.label ?? field.field,
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            setState(() {
              isBottom = !isBottom;
              selected = field;
              switch (field.type!.toLowerCase()) {
                case "string":
                  isString = !isString;
                case "number":
                  isNumber = !isNumber;
                case "boolean":
                  isBool = !isBool;
                case "date":
                  isDate = !isDate;
              }
            });
          },
        ));
      }
    }

    return widget.show
        ? DraggableScrollableSheet(
            shouldCloseOnMinExtent: true,
            minChildSize: 0.2,
            builder: (BuildContext context, ScrollController sheetController) {
              change = 1;
              if (!isBottom) listofFieldTiles();
              return ColoredBox(
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    Grabber(
                      onVerticalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          _sheetPosition -= details.delta.dy / _dragSensitivity;
                          if (_sheetPosition < 0.25) {
                            _sheetPosition = 0.25;
                          }
                          if (_sheetPosition > 1.0) {
                            _sheetPosition = 1.0;
                          }
                        });
                      },
                      isOnDesktopAndWeb: _isOnDesktopAndWeb,
                    ),
                    Flexible(
                      child: ListView.builder(
                        controller: _isOnDesktopAndWeb ? null : sheetController,
                        itemCount: listofTiles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return listofTiles[index];
                        },
                      ),
                    ),
                  ]));
            })
        : SizedBox.shrink();
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: colorScheme.onSurface,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
