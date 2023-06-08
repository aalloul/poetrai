import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../data_layer/poem.dart';
import '../generated/l10n.dart';
import '../utils.dart';


class PoetrAIAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isWebMobile;
  const PoetrAIAppBar(this.isWebMobile, {super.key});

  @override
  State<StatefulWidget> createState() => _PoetrAIAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PoetrAIAppBar extends State<PoetrAIAppBar> {

  @override
  Widget build(BuildContext context) {
    CookieData cookieData = Provider.of<CookieData>(context, listen: true);

    return Selector<Poem, String>(
      selector: (_, poem) => poem.todaysWord,
      builder: (context, data, child) => AppBar(
        title: title(),
        actions: [showStatsButton(context, cookieData, data), extendRulesButton(context)],
      )
    );

  }

  Widget title() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/poetai-logo-64x64.png",
          scale: 6.25,
        ),
        kDebugMode ? const Text("PoetrAI v0.0.1 - ") : const Text("PoetrAI")
      ],
    );
  }

  Widget showStatsButton(BuildContext context, CookieData cookieData, String todayWord) {
    printIfDebug("cookieData cookieData.lastGameWord.word = ${cookieData.lastGameWord().word}");
    printIfDebug("cookieData cookieData.totalGames = ${cookieData.totalGames.getValue()}");

    return MaterialButton(
      elevation: 3,
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => showGameStats(_, cookieData, todayWord)
        );
      },
      padding: EdgeInsets.zero,
      child: const Icon(Icons.bar_chart, color: Colors.white),
    );
  }

  AlertDialog showGameStats(BuildContext context, CookieData cookieData, String todayWord) {
    // widget.analytics.logEvent(name: "ShowGameStats");
    bool comebackTomorrow =
        cookieData.lastGameWord().word == todayWord;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 50.0,
        vertical: 100.0,
      ),
      title: Text(S.of(context).game_stats,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24.0,
              color: Colors.black)),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            keyMetricsRow(context, cookieData),
            SizedBox(
              width: 300,
              height: 200,
              child: statChart(context, cookieData),
            ),
            const SizedBox(
              height: 40,
            ),
            showComebackTomorrowMessage(comebackTomorrow)
          ]),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getFeedbackButton(context),
            getShareButton(cookieData.boxesForShareMessage.getValue())
          ],
        )
      ],
    );
  }

  Widget keyMetricsRow(BuildContext context, CookieData cookieData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        keyMetricCard(
            S.of(context).games_played, cookieData.totalGames.getValue().toString()),
        keyMetricCard(
            S.of(context).games_won, cookieData.successfulGames.getValue().toString()),
        keyMetricCard(
            S.of(context).games_lost, cookieData.unsuccessfulGames().toString()),
        keyMetricCard(S.of(context).avg_number_attempts,
            cookieData.averageAttemptsToWin().toString()),
      ],
    );
  }

  Widget keyMetricCard(String title, String value) {
    return Expanded(
        child: Card(
          elevation: 1,
          shape: getRoundedRectangle(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 1.0),
                    child: Text(value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.black))),
                Padding(
                    padding: const EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 8.0),
                    child: Text(title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.black)))
              ]),
        ));
  }

  Widget statChart(BuildContext context, CookieData cookieData) {
    return SfCartesianChart(
        title: ChartTitle(
            text: S.of(context).detailed_stats,
            textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                color: Colors.black)),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          isVisible: false,
          minimum: 0,
          maximum: cookieData.totalGames.getValue().toDouble(),
        ),
        tooltipBehavior: TooltipBehavior(enable: false),
        series: <ChartSeries<ChartData, String>>[
          BarSeries<ChartData, String>(
              dataSource: userStatsForChart(cookieData),
              xValueMapper: (ChartData data, _) => data.barTitle,
              yValueMapper: (ChartData data, _) => data.barValue,
              pointColorMapper: (ChartData data, _) =>
              data.barTitle == "X" ? Constants.imperfectGuess : Constants.perfectGuess,
              // color: perfectGuess,
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]);
  }

  List<ChartData> userStatsForChart(CookieData cookieData) {
    return [
      ChartData("X", cookieData.unsuccessfulGames()),
      ChartData("5", cookieData.gamesWonIn5.getValue()),
      ChartData("4", cookieData.gamesWonIn4.getValue()),
      ChartData("3", cookieData.gamesWonIn3.getValue()),
      ChartData("2", cookieData.gamesWonIn2.getValue()),
      ChartData("1", cookieData.gamesWonIn1.getValue()),
    ];
  }

  Widget showComebackTomorrowMessage(bool shouldDisplay) {
    if (shouldDisplay) {
      return Text(S.of(context).comeback_tomorrow);
    } else {
      return Container();
    }
  }

  Widget getFeedbackButton(BuildContext context) {
    return TextButton(
        onPressed: _launchUrl, child: Text(S.of(context).share_feedback));
  }

  Future<void> _launchUrl() async {
    final Uri feedbackUrl = Uri.parse('https://forms.gle/CivZvq2Gw4BDZn2B8');

    if (!await launchUrl(feedbackUrl)) {
      throw 'Could not launch $feedbackUrl';
    }
  }

  Widget extendRulesButton(BuildContext context) {
    return MaterialButton(
      elevation: 3.0,
      onPressed: () {},
      padding: EdgeInsets.zero,
      child: const Icon(Icons.question_mark, color: Colors.white),
    );
  }

  Widget getShareButton(String boxesForMessage) {
    return Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () => _onShare(context, boxesForMessage),
          child: Text(S.of(context).share_button),
        );
      },
    );
  }

  void _onShare(BuildContext context, String boxesForMessage) async {
    // widget.analytics.logEvent(name: "Share app");

    if (widget.isWebMobile) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(shareTextMessage(context, boxesForMessage),
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Clipboard.setData(
          ClipboardData(text: shareTextMessage(context, boxesForMessage)));
      showDialog(
          context: context,
          builder: (cont) {
            Future.delayed(const Duration(seconds: 1)).then((_) {
              Navigator.of(context).pop();
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: const BorderSide(width: 1, color: Colors.grey)),
              content: const Text("Copied to clipboard"),
              // actionsAlignment: MainAxisAlignment.spaceBetween,
              backgroundColor: Colors.white,
            );
          });
    }
  }

  String shareTextMessage(BuildContext context, String boxesforMessage) {
    String out =
    S.of(context).share_text(todayInFullWords());
    out += "\n$boxesforMessage";
    out += "\n${S.of(context).giveItATry}";
    return out;
  }

}
