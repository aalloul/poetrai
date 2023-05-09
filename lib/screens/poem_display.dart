import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoemDisplay extends StatelessWidget {
  const PoemDisplay({Key? key}) : super(key: key);
  static final List<String> poem = [
    "Lorem ipsum dolor sit amet, consectetur.\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet.",
    "Lorem ipsum dolor sit amet, consectetur.\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet.",
    "Lorem ipsum dolor sit amet, consectetur.\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet.",
    "Lorem ipsum dolor sit amet, consectetur.\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet..\nPhasellus rhoncus lectus at lorem laoreet.",
  ];

  @override
  Widget build(BuildContext context) {
    return verseHolders();
  }

  Widget verseHolders() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(
          //   width: 40,
          // ),
          verseRow(
            poem[0],
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          verseRow(
            poem[1],
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          verseRow(
            poem[2],
          ),
          const SizedBox(
            height: 10,
            child: Text(""),
          ),
          verseRow(
            poem[3],
          ),
          // const SizedBox(
          //   width: 40,
          // ),
        ]);
  }

  Widget verseRow(String verse) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Flexible(flex: 1, child: SizedBox()),
        Flexible(
          flex: 8,
          child: wrapVerseInText(verse),
        ),
        const Flexible(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget wrapVerseInText(String verse) {
    return Text(verse,
        style: GoogleFonts.architectsDaughter(fontWeight: FontWeight.w700));
  }
}
