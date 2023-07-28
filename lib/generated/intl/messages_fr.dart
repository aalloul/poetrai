// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(word) =>
      "En effet, il fallait trouver le mot ${word}! Reviens demain pour une nouvelle partie :)";

  static String m1(word) =>
      "Le mot d\'aujourd\'hui est ${word} mais ne t\'inquiète, demain tu auras la possibilité de retenter ta chance avec un autre poême";

  static String m2(poem, url) =>
      "Peux-tu deviner le titre de ce poême:\n\n${poem}\n\nEssaie ici ${url} \n";

  static String m3(poem, n, url) =>
      "Peux-tu deviner le titre de ce poême:\n\n${poem}\n\nMon score aujourd\'hui ${n}/5.\n\n${url}\n";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "avg_number_attempts":
            MessageLookupByLibrary.simpleMessage("Coups moyen"),
        "back_to_game": MessageLookupByLibrary.simpleMessage("Revenir au jeu"),
        "comeback_tomorrow": MessageLookupByLibrary.simpleMessage(
            "Reviens demain pour un nouveau jeu!"),
        "comeback_tomorrow_but_share": MessageLookupByLibrary.simpleMessage(
            "Reviens demain pour un nouveau poême mais pour le moment, tu peux partager ⤵️"),
        "congratulations":
            MessageLookupByLibrary.simpleMessage("Félicitations !"),
        "correct_word": m0,
        "detailed_rules": MessageLookupByLibrary.simpleMessage(
            "<html><body>\n<div><h3>C\'est quoi PoetAI?</h3><p>On a demandé à une IA d\'écrire un poême à partir d\'un mot. Le jeu est de deviner ce mot en 5 essais ou moins!</p\n><h3>Comment jouer? </h3>\n    <p>Imaginons que le mot à deviner est serpent. Le jeu commence en affichant la 1ère partie du poême</p>\n    <p style=\"text-align: center\"><i>In tangled coils, a sleek and slender form,<br>\n        Unveiling secrets, nature\'s enigma born.<br>\n        Silent slither, a creature of mystique,<br>\n        Serpent whispers, a language unique.</i></p>\n    <p>Si tu tapes souris (par exemple), les letters S et R sur le clavier s\'afficheront en <span style=\"color: orange\">orange</span> et la partie suivante du poême s\'affichiera.</p>\n    <p>Tu as 4 autres essais pour deviner le bon mot!</p>\n    <p>Chaque jour à minuit CEST, un nouveau poême est publié et tu pourras retenter ta chance</p>\n</div>\n</body>\n</html>"),
        "detailed_stats":
            MessageLookupByLibrary.simpleMessage("Distribution de tes jeux"),
        "game_stats": MessageLookupByLibrary.simpleMessage("Statistiques"),
        "games_lost": MessageLookupByLibrary.simpleMessage("Perdus"),
        "games_played": MessageLookupByLibrary.simpleMessage("Joués"),
        "games_won": MessageLookupByLibrary.simpleMessage("Gagnés"),
        "guess_todays_word": MessageLookupByLibrary.simpleMessage(
            "Devine le mot d\'aujourd\'hui"),
        "incorrect_word": m1,
        "lets_go": MessageLookupByLibrary.simpleMessage("Allons-y !"),
        "not_in_word_list":
            MessageLookupByLibrary.simpleMessage("Pas dans la liste des mots"),
        "open_game": MessageLookupByLibrary.simpleMessage("Commencer"),
        "share_button": MessageLookupByLibrary.simpleMessage("Partager"),
        "share_feedback":
            MessageLookupByLibrary.simpleMessage("Donne-nous ton avis"),
        "share_text": m2,
        "share_text_win": m3,
        "short_description": MessageLookupByLibrary.simpleMessage(
            "Nous avons demandé à une IA d\'écrire un poême à partir d\'un mot. Sauras-tu deviner ce mot ?"),
        "too_bad": MessageLookupByLibrary.simpleMessage("Dommage !"),
        "type_a_word": MessageLookupByLibrary.simpleMessage("Tape un mot"),
        "welcome": MessageLookupByLibrary.simpleMessage("Bienvenu à PoetAI"),
        "win_rate": MessageLookupByLibrary.simpleMessage("% Gagnés")
      };
}
