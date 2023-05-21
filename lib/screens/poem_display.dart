import 'package:flutter/material.dart';
import 'package:poetrai/data_layer/poem.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';

class PoemDisplay extends StatelessWidget {
  const PoemDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Poem poem = Provider.of<Poem>(context, listen: true);
    return Selector<UserInputProvider, int>(
        selector: (_, userInputProvider) => userInputProvider.attemptNumber,
        builder: (context, data, child) => verseHolders(poem, data));
  }

  List<Widget> columnChildren(Poem poem, int attemptNumber) {
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

  Widget verseHolders(Poem poem, int attemptNumber) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
            flex: 7,
            child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: columnChildren(poem, attemptNumber))),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget wrapVerseInText(String verse) {
    return Text(verse, style: const TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.center,);
  }
}
