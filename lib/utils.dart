import 'dart:math';
import 'package:flutter/material.dart';
import 'package:timezone/browser.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

void printIfDebug(String message) {
  if (kDebugMode) {
    print(message);
  }
}

String pickRandomElementFromList(List<String> inputList) {
  Random generator = Random();
  return inputList[generator.nextInt(inputList.length)];
}

DateTime today() {
  var todayDate = tz.TZDateTime.now(tz.getLocation('Europe/Paris'));
  return todayDate;
}

String todayInFullWords() {
  final DateFormat formatter = DateFormat('dd MMMM y');
  return formatter.format(today());
}

String todayAsString() {
  // Returns the date as %Y%m%d
  final DateTime todayDate = today();
  String formattedDate = "${todayDate.year}";
  if (todayDate.month < 10) {
    formattedDate += "0${todayDate.month}";
  } else {
    formattedDate += "${todayDate.month}";
  }
  if (todayDate.day < 10) {
    formattedDate += "0${todayDate.day}";
  } else {
    formattedDate += "${todayDate.day}";
  }
  return formattedDate;
}

RoundedRectangleBorder getRoundedRectangle() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(3.0),
  );
}

class ChartData {
  String barTitle;
  int barValue;

  ChartData(this.barTitle, this.barValue);
}
