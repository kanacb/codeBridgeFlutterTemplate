import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

final random = Random();

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);


// whatsapp urls
const String whatsappIOS = 'whatsapp://wa.me/60122222222';
const String whatsappAND = 'whatsapp://send?phone=60122222222';

// formats
DateFormat dateFormat = DateFormat('dd/MM/yyyy');
DateFormat timeFormat = DateFormat('dd/MM/yyyy');

//colors
const Color colorPrimary = Color(0xFFCAD2EB);
const Color colorSecondary = Color(0xFF554D4D);
const Color colorWarning = Color(0xFF82500A);
const Color colorDanger = Color(0xFFAB040B);
const Color colorError = Color(0xFFF14343);
const Color colorHelp = Color(0xFF5A0A82);