import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void snackBarException(BuildContext context, Exception e, String message) {
  var snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  if (kDebugMode) {
    print('error caught: $e');
  }
}