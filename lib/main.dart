// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:study/firebase_options.dart';
// import 'package:study/screens/homepage/homepage.screen.dart';
// import 'package:study/screens/login/login.screen.dart';
import 'router_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleService.instance.init(
    deviceLocale: true,
    defaultLocale: 'ko',
    fallbackLocale: 'en',
    useKeyAsDefaultText: true,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      title: 'Flutter Study',

      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [Locale('en'), Locale('ko')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
