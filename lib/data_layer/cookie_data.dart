import 'package:poetrai/data_layer/word.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

class CookieDataReader {
  Stream<CookieData> readData() async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    yield CookieData.fromSharedPreferences(sharedPreferences);
  }
}

class CookieData {
  int totalGames;
  int successfulGames;
  int gamesWonIn1;
  int gamesWonIn2;
  int gamesWonIn3;
  int gamesWonIn4;
  int gamesWonIn5;
  String appVersion;
  String boxesForShareMessage;
  String stringWord;
  late int unsuccessfulGames;
  late Word lastGameWord;

  CookieData({
    this.stringWord = "",
    this.totalGames = 0,
    this.successfulGames = 0,
    this.gamesWonIn1 = 0,
    this.gamesWonIn2 = 0,
    this.gamesWonIn3 = 0,
    this.gamesWonIn4 = 0,
    this.gamesWonIn5 = 0,
    this.boxesForShareMessage = "",
    this.appVersion = "1.0",
  }) {
    printIfDebug("CookieData constructor - stringWord = $stringWord");
    lastGameWord = Word(stringWord);
    unsuccessfulGames = totalGames - successfulGames;
  }

  factory CookieData.fromSharedPreferences(
      SharedPreferences sharedPreferences) {
    return CookieData(
      stringWord: sharedPreferences.getString("previousWord") ?? "",
      appVersion: sharedPreferences.getString("appVersion") ?? "unk",
      successfulGames: (sharedPreferences.getInt('numberWins') ?? 0),
      totalGames: (sharedPreferences.getInt('numberGames') ?? 0),
      boxesForShareMessage:
          sharedPreferences.getString("boxesForShareMessage") ?? "",
      gamesWonIn1: sharedPreferences.getInt("wonIn1") ?? 0,
      gamesWonIn2: sharedPreferences.getInt("wonIn2") ?? 0,
      gamesWonIn3: sharedPreferences.getInt("wonIn3") ?? 0,
      gamesWonIn4: sharedPreferences.getInt("wonIn4") ?? 0,
      gamesWonIn5: sharedPreferences.getInt("wonIn5") ?? 0,
    );
  }

  CookieData getNewCookieData(String todayWord, int numberAttempts,
      bool isGameSuccessful, String boxesForMessage) {
    CookieData newCookieData = CookieData(
        stringWord: todayWord,
        totalGames: totalGames + 1,
        boxesForShareMessage: boxesForMessage);

    if (isGameSuccessful) {
      newCookieData.successfulGames = successfulGames + 1;
      switch (numberAttempts) {
        case 1:
          newCookieData.gamesWonIn1 = gamesWonIn1 + 1;
          break;
        case 2:
          newCookieData.gamesWonIn2 = gamesWonIn2 + 2;
          break;
        case 3:
          newCookieData.gamesWonIn3 = gamesWonIn3 + 3;
          break;
        case 4:
          newCookieData.gamesWonIn4 = gamesWonIn4 + 1;
          break;
        default:
          newCookieData.gamesWonIn5 = gamesWonIn5 + 1;
          break;
      }
    }
    return newCookieData;
  }
}

void updateCookieData(CookieData cookieData, String todayWord, int numberAttempts,
    bool isGameSuccessful, String boxesForMessage) {
  CookieData newCookieData = cookieData.getNewCookieData(
      todayWord, numberAttempts, isGameSuccessful, boxesForMessage);

  SharedPreferences.getInstance().then((sharedPreferences) {
    sharedPreferences.setInt("numberGames", newCookieData.totalGames);
    sharedPreferences.setString(
        "boxesForShareMessage", newCookieData.boxesForShareMessage);
    sharedPreferences.setString("appVersion", newCookieData.appVersion);

    if (isGameSuccessful) {
      sharedPreferences.setInt("numberWins", newCookieData.successfulGames);
      sharedPreferences.setInt("wonIn1", newCookieData.gamesWonIn1);
      sharedPreferences.setInt("wonIn2", newCookieData.gamesWonIn2);
      sharedPreferences.setInt("wonIn3", newCookieData.gamesWonIn3);
      sharedPreferences.setInt("wonIn4", newCookieData.gamesWonIn4);
      sharedPreferences.setInt("wonIn5", newCookieData.gamesWonIn5);
    }
    if (todayWord.isNotEmpty) {
      sharedPreferences.setString("previousWord", todayWord);
    }
  });
}
