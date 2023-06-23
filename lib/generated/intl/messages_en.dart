// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(word) =>
      "Indeed, the word today was ${word}! Come back tomorrow for a new game :)";

  static String m1(word) =>
      "The word of today was ${word} but worry not, tomorrow you\'ll get to try again with a new poem!";

  static String m2(poem) =>
      "Can you guess what this poem is about:\n\n${poem}\n\nTry it out at https://poetai.app\n";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "avg_number_attempts":
            MessageLookupByLibrary.simpleMessage("Avg attempts"),
        "back_to_game": MessageLookupByLibrary.simpleMessage("Back to game"),
        "comeback_tomorrow": MessageLookupByLibrary.simpleMessage(
            "Come back tomorrow to try again!"),
        "congratulations":
            MessageLookupByLibrary.simpleMessage("Congratulations !"),
        "correct_word": m0,
        "detailed_rules": MessageLookupByLibrary.simpleMessage(
            "<div><h3>What is PoetAI?</h3><p>We asked an AI to write poems around a specific word. Your task is to guess this word in 5 attempts or less!</p><h3>How to play? </h3>\n    <p>Let\'s assume the word to guess is snake. The game will start with displaying the 1st part of the poem</p>\n    <p style=\"text-align: center\"><i>In tangled coils, a sleek and slender form,<br>\n    Unveiling secrets, nature\'s enigma born.<br>\n    Silent slither, a creature of mystique,<br>\n    Serpent whispers, a language unique.</i></p>\n    <p>If you typed mouse (incorrect guess), the letters S and E on the keyboard will be colored in <span style=\"color: orange\">orange</span> and the next part of the poem will appear.</p>\n    <p>You have 4 more attempts to guess the correct word!</p>\n    <p>Every day at midnight CEST, a new poem is released and you get to guess the new word</p>\n</div>"),
        "detailed_stats":
            MessageLookupByLibrary.simpleMessage("Guess distribution"),
        "game_stats": MessageLookupByLibrary.simpleMessage("Statistics"),
        "games_lost": MessageLookupByLibrary.simpleMessage("Lost"),
        "games_played": MessageLookupByLibrary.simpleMessage("Played"),
        "games_won": MessageLookupByLibrary.simpleMessage("Won"),
        "incorrect_word": m1,
        "not_in_word_list":
            MessageLookupByLibrary.simpleMessage("Not in word list"),
        "open_game": MessageLookupByLibrary.simpleMessage("Start the game"),
        "share_button": MessageLookupByLibrary.simpleMessage("Share"),
        "share_feedback":
            MessageLookupByLibrary.simpleMessage("Give us your feedback"),
        "share_text": m2,
        "too_bad": MessageLookupByLibrary.simpleMessage("Too bad !"),
        "type_a_word": MessageLookupByLibrary.simpleMessage("Type a word"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to PoetAI"),
        "win_rate": MessageLookupByLibrary.simpleMessage("% Won")
      };
}
