import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:provider/provider.dart';


class PoetrAIAppBar extends StatefulWidget with PreferredSizeWidget {
  const PoetrAIAppBar({super.key});

  @override
  State<StatefulWidget> createState() => _PoetrAIAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PoetrAIAppBar extends State<PoetrAIAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CookieData>(
      builder: (context, cookieData, child) {
        return AppBar(
          title: title(),
          actions: [showStatsButton(context, cookieData), extendRulesButton(context)],
        );
      },
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

  Widget showStatsButton(BuildContext context, CookieData cookieData) {
    return MaterialButton(
      elevation: 3,
      onPressed: () {
        showSnackBar(cookieData);
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

  void showSnackBar(CookieData cookieData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(width: 1, color: Colors.grey)),
        content: Text(
          "Total Games ${cookieData.totalGames}, word ${cookieData.lastGameWord.word}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white),
        ),
        width: 200,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
