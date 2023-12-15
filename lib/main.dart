import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers.dart';
import 'package:flutter_demo/locales.dart';
import 'package:flutter_demo/pages/landing.dart';
import 'package:flutter_demo/providers/auth.dart';
import 'package:flutter_demo/route_generator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        // we just use one provider but we could have extra ones in here
      ],
      child: LocalizationProvider(
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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
            fontFamily: 'GochiHand-Regular',
          ),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          home: const LandingPage(),
        ),
      ),
    );
  }
}
