import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:poetrai/data_layer/poem.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../generated/l10n.dart';

class PoemDisplay extends StatelessWidget {
  const PoemDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Poem poem = Provider.of<Poem>(context, listen: true);
    return Selector2<UserInputProvider, CookieData, Tuple3<int, bool, bool>>(
        selector: (_, userInputProvider, cookieData) => Tuple3(
            userInputProvider.attemptNumber,
            userInputProvider.gameOver,
            cookieData.lastGameWord().word == poem.todaysWord),
        builder: (context, data, child) {
          return verseHolders(poem, data.item1, data.item2, data.item3);
        });
  }

  List<Widget> columnChildren(Poem poem, int attemptNumber, bool hasFinished) {
    switch (attemptNumber) {
      case 0:
        return [
          wrapVerseInText(
            poem.poemPart1,
          ),
        ];
      case 1:
        return [
          // const SizedBox(
          //   width: 40,
          // ),
          wrapVerseInText(
            poem.poemPart1,
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          wrapVerseInText(
            poem.poemPart2,
          )
        ];
      case 2:
        return [
          // const SizedBox(
          //   width: 40,
          // ),
          wrapVerseInText(
            poem.poemPart1,
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          wrapVerseInText(
            poem.poemPart2,
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          wrapVerseInText(
            poem.poemPart3,
          ),
        ];
      default:
        return [
          hasFinished ? displayPoemTitle(poem.todaysWord) : Container(),
          hasFinished
              ? const SizedBox(
                  height: 60,
                )
              : Container(),
          wrapVerseInText(
            poem.poemPart1,
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          wrapVerseInText(
            poem.poemPart2,
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          wrapVerseInText(
            poem.poemPart3,
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          wrapVerseInText(
            poem.poemPart4,
          ),
        ];
    }
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

  Widget displayPoemTitle(String title) {
    return Text(
      toBeginningOfSentenceCase(title)!,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          fontSize: 18),
      textAlign: TextAlign.center,
    );
  }


}
