import 'package:flutter/foundation.dart';
import 'package:poetrai/constants.dart';
import 'package:poetrai/data_layer/dictionary.dart';

import '../utils.dart';

class UserInputProvider extends ChangeNotifier {
  String _currentUserInput = "";

  String get currentUserInput => _currentUserInput;

  Set<String> _lettersFound = <String>{};

  Set<String> get lettersFound => _lettersFound;

  bool _hasWon = false;

  bool get hasWon => _hasWon;

  bool _wordDoesNotExist = false;

  bool get wordDoesNotExist => _wordDoesNotExist;

  bool _currentWordIsEmpty = false;

  bool get currentWordIsEmpty => _currentWordIsEmpty;

  bool _gameOver = false;

  bool get gameOver => _gameOver;

  int _attemptNumber = 0;

  int get attemptNumber => _attemptNumber;

  UserInputProvider();

  String get boxesForShareMessage => "";

  void addLetterUserInput(String letter) {
    if (_gameOver) {
      printIfDebug("Game is finished - disable editing");
      return;
    } else {
      _currentUserInput += letter;

      printIfDebug("Adding letter $letter");
      printIfDebug("new word is $_currentUserInput");
      notifyListeners();
    }
  }

  void deleteLastInputLetter() {
    if (_gameOver) {
      printIfDebug("Game is finished - disable editing");
      return;
    } else {
      printIfDebug("Delete last letter");
      if (_currentUserInput.length <= 1) {
        _currentUserInput = "";
      } else {
        _currentUserInput =
            _currentUserInput.substring(0, _currentUserInput.length - 1);
      }
      printIfDebug("new word is $_currentUserInput");
      notifyListeners();
    }
  }

  void commit(Dictionary dictionary, String todaysWord, String previousWord) {
    if (_gameOver) {
      printIfDebug("Game over - disable commit");
      return;
    }
    if (todaysWord == previousWord) {
      printIfDebug("Today's word == previous word => user already played");
      return;
    }

    if (_currentUserInput.isEmpty) {
      notifyCurrentWordIsEmpty();
    } else if (!dictionary.containsWord(_currentUserInput)) {
      printIfDebug("word $_currentUserInput does not exists");
      notifyWordDoesNotExist();
    } else {
      compareToCurrentWord(todaysWord);
      _currentUserInput = "";
    }
  }

  void compareToCurrentWord(String todaysWord) {
    printIfDebug(
        "comparing _currentUserInput=$_currentUserInput and todaysWord=$todaysWord");
    if (_currentUserInput == todaysWord) {
      printIfDebug("currentWord = todaysWord");
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
    _gameOver = _hasWon || _attemptNumber == Constants.attemptNumbers;

    printIfDebug("lettersFound = $lettersFound");
    notifyListeners();
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
