import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:poetrai/data_layer/poem.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../constants.dart';
import '../data_layer/giphy_api.dart';
import '../generated/l10n.dart';
import '../utils.dart';

class GameOverDialog extends StatelessWidget {
  final bool isWebMobile;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const GameOverDialog({
    Key? key,
    required this.isWebMobile,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CookieData cookieData = Provider.of<CookieData>(context, listen: true);
    Poem poem = Provider.of<Poem>(context, listen: true);
    return Selector<UserInputProvider, Tuple3<bool, bool, int>>(
      selector: (_, userInputProvider) => Tuple3(userInputProvider.gameOver,
          userInputProvider.hasWon, userInputProvider.attemptNumber),
      builder: (context, data, child) => emptyContainer(
          context, data.item1, data.item2, data.item3, cookieData, poem),
      shouldRebuild: (before, after) {
        return before.item1 != after.item1;
      },
    );
  }

  Widget emptyContainer(BuildContext context, bool gameOver, bool hasWon,
      int attemptNumber, CookieData cookieData, Poem poem) {
    if (poem.loading) {
      return Container();
    }

    bool displayWelcome = (poem.todaysWord.isNotEmpty) &
        (poem.todaysWord != cookieData.stringWord.getValue()) &
        (!gameOver) &
        (cookieData.totalGames.getValue() < 4);

    if (gameOver) {
      printIfDebug("emptyContainer - gameOver");
      cookieData.update(poem.todaysWord, attemptNumber, hasWon);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        analytics.logLevelEnd(levelName: "1stWord");
        showGameOverDialog(context, attemptNumber, hasWon, poem);
      });
    } else if (displayWelcome) {
      printIfDebug("display Welcome message - gaveOver = $gameOver");
      SchedulerBinding.instance.addPostFrameCallback((_) {
        displayWelcomeMessage(context);
      });
    }
    printIfDebug("emptyContainer - not gameOver");
    return Container();
  }

  showGameOverDialog(
      BuildContext context, int attemptNumber, bool hasWon, Poem poem) {
    printIfDebug("showGameOverDialog");
    Timer? timer = Timer(const Duration(milliseconds: 5000), (){
      Navigator.of(context, rootNavigator: true).pop();
    });
    return showDialog(
        context: context,
        builder: (_) => FutureBuilder<String>(
            future: getGiphy(attemptNumber+1),
            builder:
                (BuildContext buildContext, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                analytics.logEvent(
                  name: hasWon ? "Successful_Game" : "Failed_Game",
                );
                return alertDialogForGameOver(
                    hasWon
                        ? S.of(context).congratulations
                        : S.of(context).too_bad,
                    hasWon
                        ? S.of(context).correct_word(poem.todaysWord)
                        : S.of(context).incorrect_word(poem.todaysWord),
                    snapshot.data!);
              } else {
                return const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()]);
              }
            })).then((value) {
              timer?.cancel();
              timer = null;
    });
  }

  AlertDialog alertDialogForGameOver(
      String title, String content, String giphyURL) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(width: 1, color: Colors.grey)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24.0, color: Constants.writingColor),
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
              textAlign: TextAlign.center,
              style: TextStyle(color: Constants.writingColor),
            )
          ]),
      actionsAlignment: MainAxisAlignment.center,
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
    );
  }

  Future<String> getGiphy(int value) {
    return GiphyAPI.getGIF(value).then((value) => value.gifURL());
  }

  displayWelcomeMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 80),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: const BorderSide(width: 1, color: Colors.grey)),
              title: Text(
                S.of(context).guess_todays_word,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                    color: Constants.writingColor),
              ),
              content: Text(
                S.of(context).short_description,
                textAlign: TextAlign.center,
                maxLines: 4,
                style: TextStyle(color: Constants.writingColor),
              ),
              actionsAlignment: MainAxisAlignment.center,
              alignment: Alignment.center,
              actions: [
                ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Constants.buttonsColor)),
                    child: Text(
                      S.of(context).lets_go,
                      style: const TextStyle(color: Colors.black),
                    )),
              ],
            ));
  }
}
