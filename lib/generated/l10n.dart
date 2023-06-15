// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Congratulations !`
  String get congratulations {
    return Intl.message(
      'Congratulations !',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Too bad !`
  String get too_bad {
    return Intl.message(
      'Too bad !',
      name: 'too_bad',
      desc: '',
      args: [],
    );
  }

  /// `You didn’t find the right word this time. Try again tomorrow!`
  String get incorrect_word {
    return Intl.message(
      'You didn’t find the right word this time. Try again tomorrow!',
      name: 'incorrect_word',
      desc: '',
      args: [],
    );
  }

  /// `You found the right word. Come back tomorrow for a new game :)`
  String get correct_word {
    return Intl.message(
      'You found the right word. Come back tomorrow for a new game :)',
      name: 'correct_word',
      desc: '',
      args: [],
    );
  }

  /// `Start the game`
  String get open_game {
    return Intl.message(
      'Start the game',
      name: 'open_game',
      desc: '',
      args: [],
    );
  }

  /// `Back to game`
  String get back_to_game {
    return Intl.message(
      'Back to game',
      name: 'back_to_game',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to PoetAI`
  String get welcome {
    return Intl.message(
      'Welcome to PoetAI',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share_button {
    return Intl.message(
      'Share',
      name: 'share_button',
      desc: '',
      args: [],
    );
  }

  /// `Can you guess what this poem is about:\n\n{poem}\n\nTry it out at https://poetai.app\n`
  String share_text(String poem) {
    return Intl.message(
      'Can you guess what this poem is about:\n\n$poem\n\nTry it out at https://poetai.app\n',
      name: 'share_text',
      desc: '',
      args: [poem],
    );
  }

  /// `Statistics`
  String get game_stats {
    return Intl.message(
      'Statistics',
      name: 'game_stats',
      desc: '',
      args: [],
    );
  }

  /// `Come back tomorrow to try again!`
  String get comeback_tomorrow {
    return Intl.message(
      'Come back tomorrow to try again!',
      name: 'comeback_tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Give us your feedback`
  String get share_feedback {
    return Intl.message(
      'Give us your feedback',
      name: 'share_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Played`
  String get games_played {
    return Intl.message(
      'Played',
      name: 'games_played',
      desc: '',
      args: [],
    );
  }

  /// `Won`
  String get games_won {
    return Intl.message(
      'Won',
      name: 'games_won',
      desc: '',
      args: [],
    );
  }

  /// `Guess distribution`
  String get detailed_stats {
    return Intl.message(
      'Guess distribution',
      name: 'detailed_stats',
      desc: '',
      args: [],
    );
  }

  /// `% Won`
  String get win_rate {
    return Intl.message(
      '% Won',
      name: 'win_rate',
      desc: '',
      args: [],
    );
  }

  /// `Lost`
  String get games_lost {
    return Intl.message(
      'Lost',
      name: 'games_lost',
      desc: '',
      args: [],
    );
  }

  /// `Avg attempts`
  String get avg_number_attempts {
    return Intl.message(
      'Avg attempts',
      name: 'avg_number_attempts',
      desc: '',
      args: [],
    );
  }

  /// `<div><h3>What is PoetAI?</h3><p>We asked an AI to write poems around a specific word. Your task is to guess this word in 5 attempts or less!</p><h3>How to play? </h3>\n    <p>Let's assume the word to guess is snake. The game will start with displaying the 1st part of the poem</p>\n    <p style="text-align: center"><i>In tangled coils, a sleek and slender form,<br>\n    Unveiling secrets, nature's enigma born.<br>\n    Silent slither, a creature of mystique,<br>\n    Serpent whispers, a language unique.</i></p>\n    <p>If you typed mouse (incorrect guess), the letters S and E on the keyboard will be colored in <span style="color: orange">orange</span> and the next part of the poem will appear.</p>\n    <p>You have 4 more attempts to guess the correct word!</p>\n    <p>Every day at midnight CEST, a new poem is released and you get to guess the new word</p>\n</div>`
  String get detailed_rules {
    return Intl.message(
      '<div><h3>What is PoetAI?</h3><p>We asked an AI to write poems around a specific word. Your task is to guess this word in 5 attempts or less!</p><h3>How to play? </h3>\n    <p>Let\'s assume the word to guess is snake. The game will start with displaying the 1st part of the poem</p>\n    <p style="text-align: center"><i>In tangled coils, a sleek and slender form,<br>\n    Unveiling secrets, nature\'s enigma born.<br>\n    Silent slither, a creature of mystique,<br>\n    Serpent whispers, a language unique.</i></p>\n    <p>If you typed mouse (incorrect guess), the letters S and E on the keyboard will be colored in <span style="color: orange">orange</span> and the next part of the poem will appear.</p>\n    <p>You have 4 more attempts to guess the correct word!</p>\n    <p>Every day at midnight CEST, a new poem is released and you get to guess the new word</p>\n</div>',
      name: 'detailed_rules',
      desc: '',
      args: [],
    );
  }

  /// `Type a word`
  String get type_a_word {
    return Intl.message(
      'Type a word',
      name: 'type_a_word',
      desc: '',
      args: [],
    );
  }

  /// `Not in word list`
  String get not_in_word_list {
    return Intl.message(
      'Not in word list',
      name: 'not_in_word_list',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
