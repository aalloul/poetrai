import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../data_layer/poem.dart';
import '../generated/l10n.dart';
import '../utils.dart';

class PoetrAIAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isWebMobile;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const PoetrAIAppBar(this.isWebMobile, this.analytics, this.observer,
      {super.key});

  @override
  State<StatefulWidget> createState() => _PoetrAIAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PoetrAIAppBar extends State<PoetrAIAppBar> {
  @override
  Widget build(BuildContext context) {
    printIfDebug("building AppBar");
    CookieData cookieData = Provider.of<CookieData>(context, listen: false);
    RenderObject.debugCheckingIntrinsics = true;

    return Selector<Poem, Tuple2<String, String>>(
        selector: (_, poem) => Tuple2(poem.todaysWord, poem.poemPart1),
        builder: (context, data, child) => AppBar(
              backgroundColor: Constants.primaryColor,
              title: title(),
              actions: [
                showStatsButton(context, cookieData, data.item1, data.item2),
                extendRulesButton(context)
              ],
            ),
      shouldRebuild: (before, after) {
          return before.item1 != after.item1;
      },
    );
  }

  Widget title() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image.asset(
        //   "assets/images/poetai-logo-64x64.png",
        //   scale: 6.25,
        // ),
        kDebugMode ? Text("PoetAI v0.0.1 - ") : Text("PoetAI")
      ],
    );
  }

  Widget showStatsButton(BuildContext context, CookieData cookieData,
      String todayWord, String poemPart1) {
    printIfDebug(
        "cookieData cookieData.lastGameWord.word = ${cookieData.lastGameWord().word}");
    printIfDebug(
        "cookieData cookieData.totalGames = ${cookieData.totalGames.getValue()}");

    return MaterialButton(
      elevation: 3,
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => showGameStats(_, cookieData, todayWord, poemPart1));
      },
      padding: EdgeInsets.zero,
      child: const Icon(Icons.bar_chart, color: Colors.white),
    );
  }

  AlertDialog showGameStats(BuildContext context, CookieData cookieData,
      String todayWord, String poemPart1) {
    widget.analytics.logEvent(name: "ShowGameStats");
    bool comebackTomorrow = cookieData.lastGameWord().word == todayWord;
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
              color: Colors.white)),
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
          children: [getFeedbackButton(context), getShareButton(poemPart1)],
        )
      ],
    );
  }

  Widget keyMetricsRow(BuildContext context, CookieData cookieData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        keyMetricCard(S.of(context).games_played,
            cookieData.totalGames.getValue().toString()),
        keyMetricCard(S.of(context).games_won,
            cookieData.successfulGames.getValue().toString()),
        keyMetricCard(S.of(context).games_lost,
            cookieData.unsuccessfulGames().toString()),
        keyMetricCard(S.of(context).avg_number_attempts,
            cookieData.averageAttemptsToWin().toString()),
      ],
    );
  }

  Widget keyMetricCard(String title, String value) {
    return Expanded(
        child: Card(
      color: Colors.transparent,
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
                        color: Colors.white))),
            Padding(
                padding: const EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 8.0),
                child: Text(title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Colors.white)))
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
                color: Colors.white)),
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
              pointColorMapper: (ChartData data, _) => data.barTitle == "X"
                  ? Constants.imperfectGuess
                  : Constants.perfectGuess,
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
      onPressed: _launchUrl,
      style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll<Color>(Constants.secondaryColor)),
      child: Text(
        S.of(context).share_feedback,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri feedbackUrl = Uri.parse('https://forms.gle/TwptFpCdNJNTHRYp8');

    if (!await launchUrl(feedbackUrl)) {
      throw 'Could not launch $feedbackUrl';
    }
  }

  Widget getShareButton(String poemPart1) {
    return Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Constants.primaryColor)),
          onPressed: () => _onShare(context, poemPart1),
          child: Text(
            S.of(context).share_button,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void _onShare(BuildContext context, String poemPart1) async {
    widget.analytics.logEvent(name: "Share app");

    if (widget.isWebMobile) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(shareTextMessage(context, poemPart1),
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Clipboard.setData(
          ClipboardData(text: shareTextMessage(context, poemPart1)));
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

  String shareTextMessage(BuildContext context, String poemPart1) {
    return S.of(context).share_text(poemPart1, Uri.base.toString());
  }

  Widget extendRulesButton(BuildContext context) {
    return MaterialButton(
      elevation: 3.0,
      onPressed: () {
        showDialog(
            context: context, builder: (_) => showGameHelpDialog(context));
      },
      padding: EdgeInsets.zero,
      child: const Icon(Icons.question_mark, color: Colors.white),
    );
  }

  showGameHelpDialog(BuildContext context) {
    widget.analytics.logEvent(name: "OpenHelp");

    AlertDialog alertDialog = AlertDialog(
      title: null,
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
              constraints: const BoxConstraints.tightForFinite(width: 540),
              child: Html(data: S.of(context).detailed_rules))),
      actions: const [
        // reusableButtons.closeGameRulesButton(S.of(context).back_to_game)
      ],
    );
    return alertDialog;
  }
}
