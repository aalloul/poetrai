import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:poetrai/data_layer/poem.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:poetrai/utils.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:blur/blur.dart';

import '../constants.dart';

class PoemDisplay extends StatelessWidget {
  const PoemDisplay({
    Key? key,
    required this.analytics,
    required this.observer,
  }) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  Widget build(BuildContext context) {
    Poem poem = Provider.of<Poem>(context, listen: true);
    return Selector2<UserInputProvider, CookieData, Tuple3<int, bool, bool>>(
        selector: (_, userInputProvider, cookieData) => Tuple3(
            userInputProvider.attemptNumber,
            userInputProvider.gameOver,
            cookieData.lastGameWord().word == poem.todaysWord),
        builder: (context, data, child) {
          if (poem.loading) {
            return Center(
                child: CircularProgressIndicator(
              color: Constants.secondaryColor,
            ));
          } else {
            if ((data.item1 == 0) & (!data.item2) & (!data.item3)) {
              analytics.logLevelStart(levelName: "1stWord");
            }
            return verseHolders(poem, data.item1, data.item2, data.item3);
          }
        });
  }

  List<Widget> columnChildren(Poem poem, int attemptNumber, bool hasFinished) {
    List<Widget> minDisplay = [
      displayPoemTitle(poem.todaysWord, attemptNumber),
      const SizedBox(
        height: 60,
      ),
      wrapVerseInText(
        poem.poemPart1,
      )
    ];
    if (attemptNumber >= 1) {
      minDisplay.addAll([
        const SizedBox(
          height: 10,
          child: Text(""),
        ),
        wrapVerseInText(
          poem.poemPart2,
        )
      ]);
    }
    if (attemptNumber >= 2) {
      minDisplay.addAll([
        const SizedBox(
          height: 10,
          child: Text(""),
        ),
        wrapVerseInText(
          poem.poemPart3,
        ),
      ]);
    }
    if (attemptNumber >= 3) {
      minDisplay.addAll([
        const SizedBox(
          height: 10,
          child: Text(""),
        ),
        wrapVerseInText(
          poem.poemPart4,
        ),
      ]);
    }
    return minDisplay;
  }

  Widget verseHolders(
      Poem poem, int attemptNumber, bool gameOver, bool isSameWordAsPrevious) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
            flex: 10,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: columnChildren(
                        poem,
                        (gameOver || isSameWordAsPrevious) ? 99 : attemptNumber,
                        (gameOver || isSameWordAsPrevious))))),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget wrapVerseInText(String verse) {
    return Text(
      verse,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          fontSize: 18),
      textAlign: TextAlign.center,
    );
  }

  Widget displayPoemTitle(String title, int attemptNumber) {
    printIfDebug("attemptNumber = $attemptNumber");
    return Blur(
        blur: 2.5*4/attemptNumber,
        blurColor: Constants.secondaryColor,
        colorOpacity: attemptNumber > Constants.attemptNumbers ? 0 : 0.5,
        child: Text(
          toBeginningOfSentenceCase(title)!,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              fontSize: 18),
          textAlign: TextAlign.center,
        ));
  }
}
