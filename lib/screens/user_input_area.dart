import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import '../constants.dart';
import '../data_layer/dictionary.dart';
import 'package:provider/provider.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tuple/tuple.dart';

import '../data_layer/poem.dart';
import '../generated/l10n.dart';

class UserInputArea extends StatelessWidget {

  const UserInputArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInputProvider userInputProvider =
        Provider.of<UserInputProvider>(context, listen: false);
    Dictionary dictionary = Provider.of<Dictionary>(context);
    Poem poem = Provider.of<Poem>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Selector<UserInputProvider, Tuple3<String, List<String>, bool>>(
            selector: (_, userInputProvider) => Tuple3(
                userInputProvider.currentUserInput,
                userInputProvider.listWords,
                userInputProvider.gameOver),
            builder: (context, data, child) {
              return currentUserInputDisplay(
                  data.item1, data.item2, data.item3);
            }),
        Selector2<UserInputProvider, CookieData, Tuple2<Set<String>, String>>(
            selector: (_, userInputProvider, cookieData) => Tuple2(
                userInputProvider.lettersFound, cookieData.lastGameWord().word),
            builder: (context, data, child) {
              return keyBoard(
                ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                userInputProvider,
                data.item1,
                null,
                poem,
                data.item2,
              );
            }),
        Selector2<UserInputProvider, CookieData, Tuple2<Set<String>, String>>(
            selector: (_, userInputProvider, cookieData) => Tuple2(
                userInputProvider.lettersFound, cookieData.lastGameWord().word),
            builder: (context, data, child) {
              return keyBoard(
                  ["a", "s", "d", "f", "g", "h", "j", "k", "l", "Delete"],
                  userInputProvider,
                  data.item1,
                  null,
                  poem,
                  data.item2);
            }),
        Selector2<UserInputProvider, CookieData, Tuple2<Set<String>, String>>(
            selector: (_, userInputProvider, cookieData) => Tuple2(
                userInputProvider.lettersFound, cookieData.lastGameWord().word),
            builder: (context, data, child) {
              return keyBoard(["z", "x", "c", "v", "b", "n", "m", "Enter"],
                  userInputProvider, data.item1, dictionary, poem, data.item2);
            },
            shouldRebuild: (before, after) {
              return before != after;
            }),
        Selector<UserInputProvider, Tuple2<bool, bool>>(
          selector: (_, userInputProvider) => Tuple2(
              userInputProvider.wordDoesNotExist,
              userInputProvider.currentWordIsEmpty),
          builder: (context, data, child) {
            return dialogPlaceHolder(
                data.item1, data.item2, context, userInputProvider);
          },
          shouldRebuild: (before, after) {
            return after.item1 || after.item2;
          },
        ),
      ],
    );
  }

  Widget currentUserInputDisplay(
      String userStringInput, List<String> listWords, bool hasWon) {
    if (hasWon) return Container();

    List<Widget> children = [
      Container(margin: const EdgeInsets.fromLTRB(0, 0, 10, 0))
    ];
    for (String word in listWords) {
      children.addAll([
        Text(
          word,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Constants.writingColor),
        ),
        Container(margin: const EdgeInsets.fromLTRB(0, 0, 10, 0))
      ]);
    }
    if (userStringInput.isNotEmpty) {
      children.add(Text(
        userStringInput,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Constants.writingColor),
      ));
    }

    return Container(
        color: Colors.black,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ));
  }

  Widget keyBoard(
      List<String> letters,
      UserInputProvider userInputProvider,
      Set<String> lettersFound,
      Dictionary? dictionary,
      Poem? poem,
      String previousWord) {
    if (poem?.todaysWord == previousWord) return Container();
    Widget lettersContainer = Container(
        color: Colors.black38,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: letters
              .map((e) => Expanded(
                  child: stylizeLetter(e, userInputProvider, lettersFound,
                      dictionary, poem, previousWord)))
              .toList(growable: false),
        ));
    List<Widget> rowChildren = [
      // lettersContainer
      // const Expanded(flex: 1, child: SizedBox()),
      Expanded(flex: 8, child: lettersContainer),
      // const Expanded(flex: 1, child: SizedBox())
    ];

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowChildren);
  }

  Widget stylizeLetter(
      String letter,
      UserInputProvider userInputProvider,
      Set<String> lettersFound,
      Dictionary? dictionary,
      Poem? poem,
      String previousWord) {
    if (letter == "Enter") {
      return IconButton(
        padding: const EdgeInsets.all(1),
        icon: Icon(
          Icons.keyboard_return,
          color: Constants.buttonsColor,
        ),
        onPressed: () {
          userInputProvider.commit(dictionary!, poem!.todaysWord, previousWord);
        },
        color: Colors.black45,
      );
    } else if (letter == "Delete") {
      return IconButton(
        padding: const EdgeInsets.all(1),
        icon: Icon(
          Icons.backspace,
          color: Constants.buttonsColor,
        ),
        onPressed: () => userInputProvider.deleteLastInputLetter(),
        color: Colors.black45,
      );
    } else {
      return Padding(
          padding: const EdgeInsets.all(2),
          child: TextButton(
            onPressed: () => (previousWord != poem?.todaysWord)
                ? userInputProvider.addLetterUserInput(letter)
                : null,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: lettersFound.contains(letter)
                  ? Colors.orange
                  : Colors.black45,
            ),
            child: Text(letter,
                style: TextStyle(color: Constants.writingColor, fontSize: 18)),
          ));
    }
  }

  showWordDoesNotExistDialog(bool wordDoesNotExist, BuildContext context) {
    return showDialog(
        context: context,
        builder: (cont) {
          return const AlertDialog(
              title: Text("Word does not exist"), content: Text("werew"));
        });
  }

  Widget dialogPlaceHolder(bool wordDoesNotExist, bool currentWordIsEmpty,
      BuildContext context, UserInputProvider userInputProvider) {
    String text = "";
    // printIfDebug(
    //     "dialogPlaceHolder - currentWordIsEmpty=$currentWordIsEmpty - wordDoesNotExist=$wordDoesNotExist");
    if (currentWordIsEmpty) {
      text = S.of(context).type_a_word;
    } else if (wordDoesNotExist) {
      text = S.of(context).not_in_word_list;
    }
    if (wordDoesNotExist || currentWordIsEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getNativeSnackBar(text, context, userInputProvider);
      });
    }
    return Container();
  }

  getSnackBar(String text, BuildContext context) {
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
            textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                color: Colors.white),
            maxLines: 1,
            message: text,
            backgroundColor: Colors.grey),
        displayDuration: const Duration(seconds: 1),
        animationDuration: const Duration(milliseconds: 800));
  }

  getNativeSnackBar(
      String text, BuildContext context, UserInputProvider userInputProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(width: 1, color: Colors.grey)),
        backgroundColor: Constants.imperfectGuess,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white),
        ),
        width: 200,
        behavior: SnackBarBehavior.floating,
        onVisible: userInputProvider.resetWordFlags,
        duration: const Duration(seconds: 1),
      ),
    );
  }

}
