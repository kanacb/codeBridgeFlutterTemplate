import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/Schema.dart';

class CBDatePickerDialog extends StatefulWidget {
  const CBDatePickerDialog({super.key, this.restorationId, required this.selected, required this.schema});
  final RouteCompletionCallback<DateTime?> selected;
  final String? restorationId;
  final Schema schema;

  @override
  State<CBDatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<CBDatePickerDialog>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: widget!.selected,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
          confirmText: "confirm",
          cancelText: "cancel",
          fieldLabelText: "Date",
          fieldHintText: "select date",
          currentDate: DateTime.now(),
          keyboardType: TextInputType.datetime,
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          _restorableDatePickerRouteFuture.present();
        },
        child: const Text('Date Picker'),
      ),
    );
  }
}
