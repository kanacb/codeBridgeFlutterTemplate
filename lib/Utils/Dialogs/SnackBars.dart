import 'package:flutter/material.dart';

class SnackBars {
  SuccessSnackBar(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.greenAccent, width: 1),
          borderRadius: BorderRadius.circular(35),
        ),
        content: Text(
          msg,
          style: TextStyle(color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        showCloseIcon: true,
        elevation: 2,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(5),
      ),
    );
  }

  FailedSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.circular(35),
      ),
      content: Text(
        msg,
        style: TextStyle(color: Colors.black87),
        textAlign: TextAlign.center,
      ),
      showCloseIcon: true,
      elevation: 2,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    ));
  }

  WarningSnackBar(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(35),
        ),
        content: Text(
          msg,
          style: TextStyle(color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        showCloseIcon: true,
        elevation: 2,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(5),
      ),
    );
  }
}
