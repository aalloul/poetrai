import 'package:flutter/material.dart';

import '../constants.dart';

class HintsRow extends StatelessWidget {
  const HintsRow({Key? key}) : super(key: key);
  static const List<String> placeHolders = ["A", "B", "C", "D", "E", "F", "G"];

  @override
  Widget build(BuildContext context) {
    return hintRow();
  }

  Widget hintRow() {
    List<Widget> textWidgets = placeHolders.map((element) {
      return Padding(
          padding: const EdgeInsets.all(3),
          child: Text(element,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                color: Constants.writingColor,
              )));
    }).toList(growable: false);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,

        children: textWidgets);
  }
}
