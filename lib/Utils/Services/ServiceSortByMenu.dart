import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Schema.dart';

class ServiceSortByMenu extends StatefulWidget {
  const ServiceSortByMenu({super.key, required this.show, this.response});
  final bool show;
  final List<Schema>? response;

  @override
  State<ServiceSortByMenu> createState() => _ServiceSortByMenu();
}

class _ServiceSortByMenu extends State<ServiceSortByMenu> {
  double _sheetPosition = 0;
  final double _dragSensitivity = 100;
  late int change = 0;
  final DraggableScrollableController sheetController =
  DraggableScrollableController();

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
        "Sort fields",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    ];

    void listofFieldTiles() {
      for (var field in widget.response!) {
        if(field.field! == "_id") continue;
        listofTiles.add(ListTile(
          title: Text(
            field.label ?? field.field,
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {},
        ));
      }
    }

    return widget.show ? DraggableScrollableSheet(
        shouldCloseOnMinExtent: true,
        builder: (BuildContext context, ScrollController sheetController) {
          change = 1;
          listofFieldTiles();
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
        }) : SizedBox.shrink();
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
