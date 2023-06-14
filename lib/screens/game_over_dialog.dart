import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:poetrai/data_layer/poem.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

import '../data_layer/giphy_api.dart';
import '../generated/l10n.dart';

class GameOverDialog extends StatelessWidget {
  final bool isWebMobile;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const GameOverDialog(
      {Key? key, required this.isWebMobile, required this.analytics, required this.observer,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CookieData cookieData = Provider.of<CookieData>(context, listen: false);

    Poem poem = Provider.of<Poem>(context, listen: true);
    return Selector<UserInputProvider, Tuple3<bool, bool, int>>(
      selector: (_, userInputProvider) => Tuple3(userInputProvider.gameOver,
          userInputProvider.hasWon, userInputProvider.attemptNumber),
      builder: (context, data, child) => emptyContainer(
          context, data.item1, data.item2, data.item3, cookieData, poem),
    );
  }

  Widget emptyContainer(BuildContext context, bool gameOver, bool hasWon,
      int attemptNumber, CookieData cookieData, Poem poem) {
    if (gameOver) {
      cookieData.update(poem.todaysWord, attemptNumber, hasWon);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showGameOverDialog(context, attemptNumber, hasWon, poem);
      });
    }
    return Container();
  }

  showGameOverDialog(
      BuildContext context, int attemptNumber, bool hasWon, Poem poem) {
    return showDialog(
        context: context,
        builder: (_) => FutureBuilder<String>(
            future: getGiphy(attemptNumber),
            builder:
                (BuildContext buildContext, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                analytics.logEvent(
                    name:
                    hasWon ? "Successful_Game" : "Failed_Game",
                    );
                return alertDialogForGameOver(
                    hasWon
                        ? S.of(context).congratulations
                        : S.of(context).too_bad,
                    hasWon
                        ? S.of(context).correct_word
                        : S.of(context).incorrect_word,
                    getShareButton(context, poem),
                    snapshot.data!);
              } else {
                return const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()]);
              }
            }));
  }

  AlertDialog alertDialogForGameOver(
      String title, String content, Widget action, String giphyURL) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(width: 1, color: Colors.grey)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24.0, color: Colors.black),
      ),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Image.network(
                  giphyURL,
                  alignment: Alignment.center,
                )),
                RotatedBox(
                    quarterTurns: 1,
                    child: Image.asset(
                      "assets/images/Poweredby_100px-White_VertLogo.png",
                      alignment: Alignment.centerLeft,
                      scale: 1.3,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              content,
              maxLines: 2,
            )
          ]),
      actions: [action],
      actionsAlignment: MainAxisAlignment.center,
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
    );
  }

  Future<String> getGiphy(int value) {
    return GiphyAPI.getGIF(value).then((value) => value.gifURL());
  }

  Widget getShareButton(BuildContext context, Poem poem) {
    return Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () => _onShare(context, poem),
          child: Text(S.of(context).share_button),
        );
      },
    );
  }

  void _onShare(BuildContext context, Poem poem) async {
    analytics.logEvent(name: "Share app");

    if (isWebMobile) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(shareTextMessage(context, poem),
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Clipboard.setData(ClipboardData(text: shareTextMessage(context, poem)));
      showDialog(
          context: context,
          builder: (cont) {
            Future.delayed(const Duration(seconds: 1)).then((_) {
              Navigator.of(context).pop();
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: const BorderSide(width: 1, color: Colors.grey)),
              content: const Text("Copied to clipboard"),
              // actionsAlignment: MainAxisAlignment.spaceBetween,
              backgroundColor: Colors.white,
            );
          });
    }
  }

  String shareTextMessage(BuildContext context, Poem poem) {
    return S.of(context).share_text(poem.poemPart1);
  }
}
