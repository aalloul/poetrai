import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poetrai/data_layer/cookie_data.dart';
import 'package:poetrai/firebase_options.dart';
import 'package:poetrai/utils.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:timezone/timezone.dart';
import '../data_layer/dictionary.dart';
import 'package:poetrai/screens/attempt_number.dart';
import 'package:poetrai/screens/game_over_dialog.dart';
import 'package:poetrai/screens/poem_display.dart';
import 'package:poetrai/screens/poetrai_appbar.dart';
import 'package:poetrai/screens/user_input_area.dart';
import 'package:poetrai/models/user_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'data_layer/poem.dart';
import 'generated/l10n.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// TODO rewards with status
// TODO multiple words a day (maybe 1 main word then 2 extra if you watch an ad)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var byteData = await rootBundle.load('packages/timezone/data/latest.tzf');
  initializeDatabase(byteData.buffer.asUint8List());
  final preferences = await StreamingSharedPreferences.instance;

  runApp(MyApp(preferences));
}

class MyApp extends StatelessWidget {
  const MyApp(this.streamingSharedPreferences, {super.key});

  final StreamingSharedPreferences streamingSharedPreferences;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    analytics.setAnalyticsCollectionEnabled(Uri.base.host == "poetai.app");

    return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'PoetAI - We asked AI to write poems!',
        theme: ThemeData(
            colorSchemeSeed: Colors.black, brightness: Brightness.dark),
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
        ],
        navigatorObservers: <NavigatorObserver>[observer],
        builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget!),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(450, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
              background: Container(color: const Color(0xFFF5F5F5)),
            ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserInputProvider()),
            FutureProvider<Dictionary>(
                create: (_) => DictionaryReader().readDictionary(),
                initialData: Dictionary([""])),
            Provider<CookieData>(
              create: (_) => CookieData(streamingSharedPreferences),
            ),
            FutureProvider<Poem>(
                create: (_) => PoemReader().readPoem(),
                initialData: Poem.empty()),
          ],
          child: Home(analytics: analytics, observer: observer),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.analytics, required this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

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
    printIfDebug("build homepage");
    return Scaffold(
        appBar: PoetrAIAppBar(isWebMobile, widget.analytics, widget.observer),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 40,
            ),
            const AttemptNumber(),
            Expanded(
                child: PoemDisplay(
              analytics: widget.analytics,
              observer: widget.observer,
              isWebMobile: isWebMobile,
            )),
            GameOverDialog(
              analytics: widget.analytics,
              observer: widget.observer,
              isWebMobile: isWebMobile,
            ),
            const UserInputArea(),
          ],
        ));
  }

  bool get isWebMobile =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);
}
