import 'package:flutter/material.dart';
import 'package:flutter_demo/audio/sounds.dart';
import 'package:flutter_demo/helpers.dart';
import 'package:flutter_demo/locales.dart';
import 'package:flutter_demo/pages/landing.dart';
import 'package:flutter_demo/providers/ads.dart';
import 'package:flutter_demo/providers/auth.dart';
import 'package:flutter_demo/providers/global.dart';
import 'package:flutter_demo/route_generator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: languages,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  await sounds.initSounds();
  await detectFirstTime();
  runApp(
    LocalizedApp(
      delegate,
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Global>(create: (_) => Global()),
          ChangeNotifierProvider<Auth>(create: (_) => Auth()),
          ChangeNotifierProvider<Ads>(create: (_) => Ads()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

Future<bool> detectFirstTime() async {
  // we can detect the first time the user opens the app
  // to show slides, popups, etc.
  var music = prefs.getBool('music');
  if (music == null) {
    await prefs.setBool('music', true);
    await prefs.setBool('darkMode', false);
    return true;
  }
  return false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        locale: Helpers.getSavedLanguage(context),
        supportedLocales: localizationDelegate.supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        debugShowCheckedModeBanner: false,
        title: translate('app_title'),
        themeMode: Provider.of<Global>(context).darkMode()
            ? ThemeMode.dark
            : ThemeMode.light,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'GochiHand-Regular',
        ),
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'GochiHand-Regular',
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        // ignore: prefer_const_constructors
        home: LandingPage(),
      ),
    );
  }
}
