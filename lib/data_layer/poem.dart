import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';

import '../utils.dart';

class PoemReader {
  // To generate the archive, use
  // `bzip2 -c -k --best poems.json > poems.bzip2`
  Future<Poem> readPoem() async {
    printIfDebug("reading the poems");
    return rootBundle.load("assets/poems/poems.bzip2").then((value) {
      String decodedVal = utf8.decode(BZip2Decoder().decodeBytes(value.buffer.asUint8List()));
      // printIfDebug("decodedVal = $decodedVal");
      return Poem.fromString(decodedVal);
    });
  }
}

class Poem {
  dynamic inputJson;

  Poem(this.inputJson);

  factory Poem.fromString(String inputString) {
    printIfDebug("todayAsString = ${todayAsString()}");
    // printIfDebug("decodedJson = ${jsonDecode(inputString)}");
    return Poem(jsonDecode(inputString)[todayAsString()]);
  }

  String get todaysWord => inputJson['todayWord'];

  String get poemPart1 => inputJson['poemPart1'];

  String get poemPart2 => inputJson['poemPart2'];

  String get poemPart3 => inputJson['poemPart3'];

  String get poemPart4 => inputJson['poemPart4'];

  factory Poem.empty() {
    return Poem({
      "todayWord": "loading",
      'poemPart1': "loading",
      'poemPart2': "loading",
      'poemPart3': "loading",
      'poemPart4': "loading",
    });
  }
}
