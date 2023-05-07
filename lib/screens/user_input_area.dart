import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poetrai/models/user_input_provider.dart';

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
        SizedBox(
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
                  data);
            },
            shouldRebuild: (before, after) {
              return before != after;
            }),
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
          style: TextStyle(fontSize: 14, color: Colors.black),
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
      Expanded(child: SizedBox(), flex: 1),
      Expanded(child: lettersContainer, flex: 5),
      Expanded(child: SizedBox(), flex: 1)
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
        padding: EdgeInsets.all(1),
        icon: Icon(
          Icons.keyboard_return,
          color: Colors.white,
        ),
        onPressed: () => userInputProvider.commit(),
        color: Colors.black45,
      );
    } else if (letter == "Delete") {
      return IconButton(
        padding: EdgeInsets.all(1),
        icon: Icon(
          Icons.backspace,
          color: Colors.white,
        ),
        onPressed: () => userInputProvider.deleteLastInputLetter(),
        color: Colors.black45,
      );
    } else {
      return Padding(
          padding: EdgeInsets.all(2),
          child: TextButton(
            child: Text(letter, style: TextStyle(color: Colors.white)),
            onPressed: () => userInputProvider.addLetterUserInput(letter),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: lettersFound.contains(letter)
                  ? Colors.orange
                  : Colors.black45,
            ),
          ));
    }
  }

  void onLetterPressed(String letter) {
    print("pressed on $letter");
  }
}
