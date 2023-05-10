import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

import '../data_layer/giphy_api.dart';
import '../generated/l10n.dart';
import '../utils.dart';

class GameOverDialog extends StatelessWidget {
  final bool isWebMobile;
  const GameOverDialog({Key? key, required this.isWebMobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInputProvider userInputProvider = Provider.of<UserInputProvider>(context, listen: false);

    return Selector<UserInputProvider, Tuple2<bool, bool>>(
      selector: (_, userInputProvider) => Tuple2(userInputProvider.gameOver, userInputProvider.hasWon),
      builder: (context, data, child) {
        return emptyContainer(context, data.item1, data.item2, userInputProvider);
      },
    );
  }

  Widget emptyContainer(BuildContext context, bool gameOver, bool hasWon, UserInputProvider userInputProvider) {
    if (gameOver) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showGameOverDialog(context, userInputProvider, hasWon);
      });
    }
    return Container();
  }

  showGameOverDialog(BuildContext context, UserInputProvider userInputProvider, bool hasWon) {
    return showDialog(
        context: context,
        builder: (_) => FutureBuilder<String>(
            future: getGiphy(userInputProvider.attemptNumber),
            builder:
                (BuildContext buildContext, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                // analytics.logEvent(
                //     name:
                //     hasWon ? "Successful_Game" : "Failed_Game",
                //     parameters: {
                //       "gamePlayed": userInputProvider.totalGamesPlayed
                //     });
                return alertDialogForGameOver(
                    hasWon ? S.of(context).congratulations : S.of(context).too_bad,
                    hasWon ? S.of(context).correct_word : S.of(context).incorrect_word,
                    getShareButton(
                        context, userInputProvider.boxesForShareMessage),
                    snapshot.data!);
              } else {
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [CircularProgressIndicator()]);
              }
            }));
  }

  AlertDialog alertDialogForGameOver(
      String title, String content, Widget action, String giphyURL) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(width: 1, color: Colors.grey)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24.0, color: Colors.black),
      ),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Image.network(
                      giphyURL,
                      alignment: Alignment.center,
                    )),
                RotatedBox(
                    quarterTurns: 1,
                    child: Image.asset(
                      "assets/images/Poweredby_100px-White_VertLogo.png",
                      alignment: Alignment.centerLeft,
                      scale: 1.3,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              content,
              maxLines: 2,
            )
          ]),
      actions: [action],
      actionsAlignment: MainAxisAlignment.center,
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
    );
  }

  Future<String> getGiphy(int value) {
    return GiphyAPI.getGIF(value).then((value) => value.gifURL());
  }

  Widget getShareButton(BuildContext context, String boxesForShareMessage) {
    return Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () => _onShare(context, boxesForShareMessage),
          child: Text(S.of(context).share_button),
        );
      },
    );
  }

  void _onShare(BuildContext context, String boxesForShareMessage) async {
    // analytics.logEvent(name: "Share app");

    if (isWebMobile) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(shareTextMessage(context, boxesForShareMessage),
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Clipboard.setData(
          ClipboardData(text: shareTextMessage(context, boxesForShareMessage)));
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

  String shareTextMessage(BuildContext context, String boxesForShareMessage) {
    String out = S.of(context).share_text(todayInFullWords());
    out += "\n$boxesForShareMessage";
    out += "\n${S.of(context).giveItATry}";
    return out;
  }

}
