import 'package:flutter/material.dart';
import 'package:poetrai/screens/attempt_number.dart';
import 'package:poetrai/screens/poem_display.dart';
import 'package:poetrai/screens/poetrai_appbar.dart';
import 'package:poetrai/screens/user_input_area.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoetrAI - Guess today\'s word based on AI-generated poetry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (context) => UserInputProvider("chainsaw"),
          child: const Home()),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => showFirstTimeLoad(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PoetrAIAppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              height: 40,
            ),
            AttemptNumber(),
            PoemDisplay(),
            SizedBox(
              height: 40,
            ),
            UserInputArea(),
          ],
        ));
  }

// bool get isWebMobile =>
//     kIsWeb &&
//         (defaultTargetPlatform == TargetPlatform.iOS ||
//             defaultTargetPlatform == TargetPlatform.android);

// showFirstTimeLoad(BuildContext context) {
//   CookieData()
//       .readData()
//       .then((value) {
//     if (value.totalGames == 0) {
//       AlertDialog alertDialog = AlertDialog(
//         title: Text(S
//             .of(context)
//             .subtitle, textAlign: TextAlign.center),
//         content: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(S
//                 .of(context)
//                 .read_help),
//             Text(S
//                 .of(context)
//                 .read_help_2),
//             Text(S
//                 .of(context)
//                 .read_help_3)
//           ],
//         ),
//         actions: [
//           closeGameRulesButton(context)
//         ],
//       );
//       showDialog(
//           context: context,
//           builder: (_) =>
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [alertDialog],
//               ));
//     }
//   });
// }

// Widget closeGameRulesButton(BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       MaterialButton(
//           child: Text(S
//               .of(context)
//               .open_game,
//               style: const TextStyle(fontSize: 20, color: Colors.lightGreen)),
//           onPressed: () {
//             Navigator.of(context).pop();
//           })
//     ],
//   );
// }
}
