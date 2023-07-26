import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:poetrai/data_layer/poem.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:poetrai/utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';
import 'package:blur/blur.dart';

import '../constants.dart';
import '../generated/l10n.dart';

class PoemDisplay extends StatelessWidget {
  const PoemDisplay({
    Key? key,
    required this.analytics,
    required this.observer,
    required this.isWebMobile,
  }) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final bool isWebMobile;

  @override
  Widget build(BuildContext context) {
    Poem poem = Provider.of<Poem>(context, listen: true);
    printIfDebug("Uri.base.toString() = ${Uri.base.toString()}");
    return SingleChildScrollView(child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 40,),
        Selector2<UserInputProvider, CookieData, Tuple3<int, bool, bool>>(
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
            }),
        Container(height: 40,),
        Selector2<UserInputProvider, CookieData, Tuple2<bool, int>>(
          selector: (_, userInputProvider, cookieData) => Tuple2(
              userInputProvider.gameOver || cookieData.lastGameWord().word == poem.todaysWord, userInputProvider.attemptNumber),
          builder: (context, data, child) {
            return getShareButton(context, poem, data.item1, data.item2);
          },
          shouldRebuild: (before, after) => after.item1 == true,
        )
      ],
    ));
  }

  List<Widget> columnChildren(Poem poem, int attemptNumber, bool hasFinished) {
    List<Widget> minDisplay = [
      displayPoemTitle(poem.todaysWord, attemptNumber),
      const SizedBox(
        height: 20,
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
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: columnChildren(
                        poem,
                        (gameOver || isSameWordAsPrevious) ? 99 : attemptNumber,
                        (gameOver || isSameWordAsPrevious)))),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget wrapVerseInText(String verse) {
    return Text(
      verse,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          fontSize: 18,
          color: Constants.writingColor
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget displayPoemTitle(String title, int attemptNumber) {
    printIfDebug("attemptNumber = $attemptNumber");
    return Text(
      toBeginningOfSentenceCase(title)!,
      style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: Constants.writingColor,
      ),
      textAlign: TextAlign.center,
    ).frosted(
      blur: blur(attemptNumber),
      frostOpacity: 1,
      frostColor: attemptNumber > Constants.attemptNumbers ? Colors.transparent : Constants.writingColor,
      padding: const EdgeInsets.all(4.0)
    );
  }

  double blur(int attemptNumber) {
    switch (attemptNumber) {
      case 1:
        return 2.0;
      case 2:
        return 2.5;
      case 3:
        return 3.5;
      case 4:
        return 4.4;
      default:
        return 0.0;
    }
  }

  Widget getShareButton(BuildContext context, Poem poem, bool gameOver, int attemptNumber) {
    if (!gameOver) return Container();
    return Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
            onPressed: () => _onShare(context, poem, attemptNumber),
            style: ButtonStyle(
                backgroundColor:
                MaterialStatePropertyAll<Color>(Constants.buttonsColor)),
            child: Text(
              S.of(context).share_button,
              style: const TextStyle(color: Colors.black),
            ));
      },
    );
  }

  void _onShare(BuildContext context, Poem poem, int attemptNumber) async {
    analytics.logEvent(name: "Share app");

    if (isWebMobile) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(shareTextMessage(context, poem, attemptNumber),
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Clipboard.setData(
          ClipboardData(text: shareTextMessage(context, poem, attemptNumber)));
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
              content: const Text("Copied to clipboard", style: TextStyle(color: Colors.black),),
              // actionsAlignment: MainAxisAlignment.spaceBetween,
              backgroundColor: Colors.white,
            );
          });
    }
  }

  String shareTextMessage(BuildContext context, Poem poem, int attemptNumber) {
    return S
        .of(context)
        .share_text_win(poem.poemPart1, attemptNumber.toString(), Uri.base.toString());
  }
}
