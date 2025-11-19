import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../App/Dash/DashboardHelp.dart';
import '../Dialogs/SnackBars.dart';

class ServiceMoreMenu extends StatefulWidget {
  const ServiceMoreMenu({super.key, required this.show});
  final bool show;

  @override
  State<ServiceMoreMenu> createState() => _ServiceMoreMenu();
}

class _ServiceMoreMenu extends State<ServiceMoreMenu> {
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
      ListTile(
        leading: Icon(Icons.link),
        title: Text('Copy Link'),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: "your text"));
          SnackBars snackBar = SnackBars();
          snackBar.SuccessSnackBar(context, "Copied to clipboard");
        },
      ),
      ListTile(
        leading: Icon(Icons.share),
        title: Text('Share'),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DashboardHelp())),
      ),
      ListTile(
        leading: Icon(Icons.cloud_download_rounded),
        title: Text('Import'),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DashboardHelp())),
      ),
      ListTile(
        leading: Icon(Icons.cloud_upload_rounded),
        title: Text('Export'),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DashboardHelp())),
      ),
      ListTile(
        leading: Icon(Icons.help_outline_sharp),
        title: Text('Share'),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DashboardHelp())),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.code),
        title: Text('Testing'),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DashboardHelp())),
      ),
      ListTile(
        leading: Icon(Icons.dataset_linked_rounded),
        title: Text('Data Seeder'),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DashboardHelp())),
      ),
    ];

    return widget.show
        ? DraggableScrollableSheet(
            shouldCloseOnMinExtent: true,
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController sheetController) {
              change = 1;
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
