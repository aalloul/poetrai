import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:archive/archive.dart';

import '../utils.dart';

class DictionaryReader {
  // To generate the archive, use
  // `bzip2 -c -k --best poems.json > poems.bzip2`
  Future<Dictionary> readDictionary() async {
    return rootBundle.load("assets/dictionary/en.bzip2").then((value) {
      return Dictionary.fromString(
          utf8.decode(BZip2Decoder().decodeBytes(value.buffer.asUint8List()))
      );
    });
  }
}

class Dictionary {
  List<String> wordsList;
  Dictionary(this.wordsList);

  bool containsWord(String word) {
    printIfDebug("Check if $word exists");
    printIfDebug("exists = ${wordsList.contains(word)}");
    return wordsList.contains(word);
  }

  factory Dictionary.fromString(String inputString) {
    return Dictionary(const LineSplitter().convert(inputString));
  }
}