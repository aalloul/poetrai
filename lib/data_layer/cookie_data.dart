import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:poetrai/data_layer/word.dart';


class CookieData {
  final Preference<int> totalGames;
  final Preference<int> successfulGames;
  final Preference<int> gamesWonIn1;
  final Preference<int> gamesWonIn2;
  final Preference<int> gamesWonIn3;
  final Preference<int> gamesWonIn4;
  final Preference<int> gamesWonIn5;
  final Preference<String> appVersion;
  final Preference<String> boxesForShareMessage;
  final Preference<String> stringWord;

  CookieData(
      StreamingSharedPreferences sharedPreferences)
      : stringWord = sharedPreferences.getString("previousWord", defaultValue: ""),
        appVersion = sharedPreferences.getString("appVersion", defaultValue: "unk"),
        successfulGames = sharedPreferences.getInt('numberWins', defaultValue: 0),
        totalGames = sharedPreferences.getInt('numberGames', defaultValue: 0),
        boxesForShareMessage = sharedPreferences.getString("boxesForShareMessage", defaultValue: ""),
        gamesWonIn1 = sharedPreferences.getInt("wonIn1", defaultValue: 0),
        gamesWonIn2 = sharedPreferences.getInt("wonIn2", defaultValue: 0),
        gamesWonIn3 = sharedPreferences.getInt("wonIn3", defaultValue: 0),
        gamesWonIn4 = sharedPreferences.getInt("wonIn4", defaultValue: 0),
        gamesWonIn5 = sharedPreferences.getInt("wonIn5", defaultValue: 0);

  int unsuccessfulGames() {
    return totalGames.getValue() - successfulGames.getValue();
  }

  Word lastGameWord() {
    return Word(stringWord.getValue());
  }

  update(String todayWord, int numberAttempts,
      bool isGameSuccessful, String boxesForMessage) {

      stringWord.setValue(todayWord);
      totalGames.setValue(totalGames.getValue() + 1);
      boxesForShareMessage.setValue(boxesForMessage);
      gamesWonIn1.setValue((isGameSuccessful && numberAttempts == 1) ? gamesWonIn1.getValue() + 1 : gamesWonIn1.getValue());
      gamesWonIn2.setValue((isGameSuccessful && numberAttempts == 2) ? gamesWonIn2.getValue() + 1 : gamesWonIn2.getValue());
      gamesWonIn3.setValue((isGameSuccessful && numberAttempts == 3) ? gamesWonIn3.getValue() + 1 : gamesWonIn3.getValue());
      gamesWonIn4.setValue((isGameSuccessful && numberAttempts == 4) ? gamesWonIn4.getValue() + 1 : gamesWonIn4.getValue());
      gamesWonIn5.setValue((isGameSuccessful && numberAttempts == 5) ? gamesWonIn5.getValue() + 1 : gamesWonIn5.getValue());
      appVersion.setValue(appVersion.getValue());
      successfulGames.setValue(isGameSuccessful ? successfulGames.getValue() + 1 : successfulGames.getValue() );
  }

  double averageAttemptsToWin() {
    if (successfulGames.getValue() == 0) return 0;
    double num = 10.0 *
        (gamesWonIn1.getValue() * 1 +
            gamesWonIn2.getValue() * 2 +
            gamesWonIn3.getValue() * 3 +
            gamesWonIn4.getValue() * 4 +
            gamesWonIn5.getValue() * 5) /
        successfulGames.getValue();

    return num.truncate() / 10.0;
  }
}

// void updateCookieData(CookieData cookieData, String todayWord,
//     int numberAttempts, bool isGameSuccessful, String boxesForMessage) {
//   CookieData newCookieData = cookieData.getNewCookieData(
//       todayWord, numberAttempts, isGameSuccessful, boxesForMessage);
//
//   SharedPreferences.getInstance().then((sharedPreferences) {
//     sharedPreferences.setInt("numberGames", newCookieData.totalGames);
//     sharedPreferences.setString(
//         "boxesForShareMessage", newCookieData.boxesForShareMessage);
//     sharedPreferences.setString("appVersion", newCookieData.appVersion);
//
//     if (isGameSuccessful) {
//       sharedPreferences.setInt("numberWins", newCookieData.successfulGames);
//       sharedPreferences.setInt("wonIn1", newCookieData.gamesWonIn1);
//       sharedPreferences.setInt("wonIn2", newCookieData.gamesWonIn2);
//       sharedPreferences.setInt("wonIn3", newCookieData.gamesWonIn3);
//       sharedPreferences.setInt("wonIn4", newCookieData.gamesWonIn4);
//       sharedPreferences.setInt("wonIn5", newCookieData.gamesWonIn5);
//     }
//
//     if (todayWord.isNotEmpty) {
//       sharedPreferences.setString("previousWord", todayWord);
//     }
//   });
// }
