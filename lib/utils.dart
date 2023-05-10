import 'dart:math';
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