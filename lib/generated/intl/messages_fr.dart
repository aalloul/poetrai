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

  static String m0(poem) =>
      "Peux-tu deviner le sujet de ce poême:\n\n${poem}\n\nEssaie ici https://poetai.app \n";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "avg_number_attempts":
            MessageLookupByLibrary.simpleMessage("Coups moyen"),
        "back_to_game": MessageLookupByLibrary.simpleMessage("Revenir au jeu"),
        "comeback_tomorrow": MessageLookupByLibrary.simpleMessage(
            "Reviens demain pour un nouveau jeu!"),
        "congratulations":
            MessageLookupByLibrary.simpleMessage("Félicitations !"),
        "correct_word": MessageLookupByLibrary.simpleMessage(
            "Tu as trouvé le bon mot! Reviens demain pour une nouvelle partie :)"),
        "detailed_rules": MessageLookupByLibrary.simpleMessage(
            "<div><h3>C\'est quoi PoetAI?</h3><p>On a demandé à une IA d\'écrire un poême à partir d\'un mot. Le jeu est de deviner ce mot en 5 essais ou moins!</p\n><h3>Comment jouer? </h3>\n    <p>Imaginons que le mot à deviner est serpent. Le jeu commence en affichant la 1ère partie du poême</p>\n    <p style=\"text-align: center\"><i>In tangled coils, a sleek and slender form,<br>\n        Unveiling secrets, nature\'s enigma born.<br>\n        Silent slither, a creature of mystique,<br>\n        Serpent whispers, a language unique.</i></p>\n    <p>Si tu tapes souris (par exemple), les letters S et R sur le clavier s\'afficheront en <span style=\"color: orange\">orange</span> et la partie suivante du poême s\'affichiera.</p>\n    <p>Tu as 4 autres essais pour deviner le bon mot!</p>\n    <p>Chaque jour à minuit CEST, un nouveau poême est publié et tu pourras retenter ta chance</p>\n</div>"),
        "detailed_stats":
            MessageLookupByLibrary.simpleMessage("Distribution de tes jeux"),
        "game_stats": MessageLookupByLibrary.simpleMessage("Statistiques"),
        "games_lost": MessageLookupByLibrary.simpleMessage("Perdus"),
        "games_played": MessageLookupByLibrary.simpleMessage("Joués"),
        "games_won": MessageLookupByLibrary.simpleMessage("Gagnés"),
        "incorrect_word": MessageLookupByLibrary.simpleMessage(
            "Tu n\'as pas trouvé le bon mot cette fois-ci. Essaie encore demain"),
        "not_in_word_list":
            MessageLookupByLibrary.simpleMessage("Pas dans la liste des mots"),
        "open_game": MessageLookupByLibrary.simpleMessage("Commencer"),
        "share_button": MessageLookupByLibrary.simpleMessage("Partager"),
        "share_feedback":
            MessageLookupByLibrary.simpleMessage("Donne-nous ton avis"),
        "share_text": m0,
        "too_bad": MessageLookupByLibrary.simpleMessage("Dommage !"),
        "type_a_word": MessageLookupByLibrary.simpleMessage("Tape un mot"),
        "welcome": MessageLookupByLibrary.simpleMessage("Bienvenu à PoetAI"),
        "win_rate": MessageLookupByLibrary.simpleMessage("% Gagnés")
      };
}
