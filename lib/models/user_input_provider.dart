import 'dart:math';

import 'package:flutter/foundation.dart';

class UserInputProvider extends ChangeNotifier {
  String _currentUserInput = "";

  String get currentUserInput => _currentUserInput;

  Set<String> _lettersFound = Set<String>();

  Set<String> get lettersFound => _lettersFound;

  bool _hasWon = false;
  bool get hasWon => _hasWon;

  bool _wordDoesNotExist = false;
  bool get wordDoesNotExist => _wordDoesNotExist;

  bool _currentWordIsEmpty = false;
  bool get currentWordIsEmpty => _currentWordIsEmpty;

  int _attemptNumber = 0;
  int get attemptNumber => _attemptNumber;

  String todaysWord;

  UserInputProvider(this.todaysWord);

  void addLetterUserInput(String letter) {
    print("Adding letter $letter");
    _currentUserInput += letter;
    print("new word is $_currentUserInput");
    notifyListeners();
  }

  void deleteLastInputLetter() {
    print("Delete last letter");
    if (_currentUserInput.length <= 1) {
      _currentUserInput = "";
    } else {
      _currentUserInput =
          _currentUserInput.substring(0, _currentUserInput.length - 1);
    }
    print("new word is $_currentUserInput");
    notifyListeners();
  }

  void commit() {
    if (_currentUserInput.isEmpty) {
      notifyCurrentWordIsEmpty();
    }
    else if (doesWordExist()) {
      notifyWordDoesNotExist();
    } else {
      compareToCurrentWord();
      _currentUserInput = "";
    }
  }

  void compareToCurrentWord() {
    if (kDebugMode) {
      print(
        "comparing _currentUserInput=$_currentUserInput and todaysWord=$todaysWord");
    }
    if (_currentUserInput == todaysWord) {
      _hasWon = true;
    } else {
      Set<String> intersection = _currentUserInput
          .split('')
          .toSet()
          .intersection(todaysWord.split('').toSet());
      intersection.addAll(_lettersFound);
      _lettersFound = intersection;
    }
    _attemptNumber += 1;
    if (kDebugMode) {
      print("lettersFound = $lettersFound");
    }
    notifyListeners();
  }

  bool doesWordExist() {
    // TODO implement this
    return (Random().nextInt(10) % 2 == 0);
  }

  void notifyCurrentWordIsEmpty() {
    _currentWordIsEmpty = true;
    notifyListeners();
  }

  void notifyWordDoesNotExist() {
    _wordDoesNotExist = true;
    notifyListeners();
  }

  void resetWordFlags() {
    _wordDoesNotExist = false;
    _currentWordIsEmpty = false;
    notifyListeners();
  }

}
