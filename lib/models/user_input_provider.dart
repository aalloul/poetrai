import 'package:flutter/foundation.dart';

class UserInputProvider extends ChangeNotifier {
  String _currentUserInput = "";
  String get currentUserInput => _currentUserInput;

  Set<String> _lettersFound = Set<String>();
  Set<String> get lettersFound => _lettersFound;

  bool _hasWon = false;
  bool get hasWon => _hasWon;

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
    print("pressed Commit");
    compareToCurrentWord();

    _currentUserInput = "";
  }

  void compareToCurrentWord() {
    print("comparing _currentUserInput=$_currentUserInput and todaysWord=$todaysWord");
    if (_currentUserInput == todaysWord) {
      _hasWon = true;
    } else {
      Set<String> intersection = _currentUserInput.split('').toSet().intersection(todaysWord.split('').toSet());
      print("intersection = $intersection");
      intersection.addAll(_lettersFound);
      _lettersFound = intersection;
    }
    print("lettersFound = $lettersFound");
    notifyListeners();
  }
}