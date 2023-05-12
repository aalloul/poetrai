import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/dictionary_reader.dart';

class PoetrAIAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  State<StatefulWidget> createState() => _PoetrAIAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PoetrAIAppBar extends State<PoetrAIAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title(),
      actions: [showStatsButton(context), extendRulesButton(context)],
    );
  }

  Widget title() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/maskable_icon_x96.png",
          scale: 1.5,
        ),
        kDebugMode ? const Text("PoetrAI v0.0.1 - ") : const Text("PoetrAI")
      ],
    );
  }

  Widget showStatsButton(BuildContext context) {
    return MaterialButton(
      elevation: 3,
      onPressed: () {
        DictionaryReader().readDictionary();
      },
      padding: EdgeInsets.zero,
      child: const Icon(Icons.bar_chart, color: Colors.white),
    );
  }

  Widget extendRulesButton(BuildContext context) {
    return MaterialButton(
      elevation: 3.0,
      onPressed: () {},
      padding: EdgeInsets.zero,
      child: const Icon(Icons.question_mark, color: Colors.white),
    );
  }
}
