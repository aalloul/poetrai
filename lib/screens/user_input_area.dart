import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:tuple/tuple.dart';

class UserInputArea extends StatelessWidget {
  const UserInputArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInputProvider userInputProvider =
        Provider.of<UserInputProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Selector<UserInputProvider, String>(
            selector: (_, userInputProvider) =>
                userInputProvider.currentUserInput,
            builder: (context, data, child) {
              return currentUserInputDisplay(data);
            }),
        const SizedBox(
          height: 10,
        ),
        Selector<UserInputProvider, Set<String>>(
            selector: (_, userInputProvider) => userInputProvider.lettersFound,
            builder: (context, data, child) {
              return keyBoard(
                  ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                  userInputProvider,
                  data);
            }),
        Selector<UserInputProvider, Set<String>>(
            selector: (_, userInputProvider) => userInputProvider.lettersFound,
            builder: (context, data, child) {
              return keyBoard(
                  ["a", "s", "d", "f", "g", "h", "j", "k", "k", "l"],
                  userInputProvider,
                  data);
            }),
        Selector<UserInputProvider, Set<String>>(
            selector: (_, userInputProvider) => userInputProvider.lettersFound,
            builder: (context, data, child) {
              return keyBoard(
                ["Enter", "z", "x", "c", "v", "b", "n", "m", "Delete"],
                userInputProvider,
                data,
              );
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
        )
      ],
    );
  }

  Widget currentUserInputDisplay(String userStringInput) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          userStringInput,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        )
      ],
    );
  }

  Widget keyBoard(List<String> letters, UserInputProvider userInputProvider,
      Set<String> lettersFound) {
    Widget lettersContainer = Container(
        color: Colors.black38,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: letters
              .map((e) => Expanded(
                  child: stylizeLetter(e, userInputProvider, lettersFound)))
              .toList(growable: false),
        ));
    List<Widget> rowChildren = [
      const Expanded(flex: 1, child: SizedBox()),
      Expanded(flex: 5, child: lettersContainer),
      const Expanded(flex: 1, child: SizedBox())
    ];

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowChildren);
  }

  Widget stylizeLetter(String letter, UserInputProvider userInputProvider,
      Set<String> lettersFound) {
    if (letter == "Enter") {
      return IconButton(
        padding: const EdgeInsets.all(1),
        icon: const Icon(
          Icons.keyboard_return,
          color: Colors.white,
        ),
        onPressed: () {
          userInputProvider.commit();
        },
        color: Colors.black45,
      );
    } else if (letter == "Delete") {
      return IconButton(
        padding: const EdgeInsets.all(1),
        icon: const Icon(
          Icons.backspace,
          color: Colors.white,
        ),
        onPressed: () => userInputProvider.deleteLastInputLetter(),
        color: Colors.black45,
      );
    } else {
      return Padding(
          padding: const EdgeInsets.all(2),
          child: TextButton(
            onPressed: () => userInputProvider.addLetterUserInput(letter),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: lettersFound.contains(letter)
                  ? Colors.orange
                  : Colors.black45,
            ),
            child: Text(letter, style: const TextStyle(color: Colors.white)),
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
    if (currentWordIsEmpty) {
      text = "Type a word";
    } else if (wordDoesNotExist) {
      text = "Not in word list";
    }
    if (wordDoesNotExist || currentWordIsEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: const BorderSide(width: 1, color: Colors.grey)),
            content: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            width: 200,
            behavior: SnackBarBehavior.floating,
            onVisible: userInputProvider.resetWordFlags,
            duration: const Duration(seconds: 1),
          ),
        );
      });
    }
    return Container();
  }
}
