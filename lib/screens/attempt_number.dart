import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';

class AttemptNumber extends StatelessWidget {
  const AttemptNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Selector<UserInputProvider, int>(
            builder: (context, data, child) {
              return CircularPercentIndicator(
                radius: 20,
                lineWidth: 5,
                percent: 1.0*data/5,
                center: getEmojiForAttempt(data),
                progressColor: progressColor(data),
              );
            },
            selector: (_, userInputProvider) => userInputProvider.attemptNumber
        ),

        const SizedBox(width: 20,),
      ],
    );
  }

  Widget getEmojiForAttempt(int attemptNumber) {
    switch (attemptNumber) {
      case 1:
        return const Text("🤩");
      case 2:
        return const Text("🙂");
      case 3:
        return const Text("🤔");
      case 4:
        return const Text("🤨");
      case 5:
        return const Text("😢");
      default:
        return const Text("");
    }
  }

  Color progressColor(int attemptNumber) {
    switch (attemptNumber) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orangeAccent;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
