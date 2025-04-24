// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:study/firebase_options.dart';
// import 'package:study/screens/homepage/homepage.screen.dart';
// import 'package:study/screens/login/login.screen.dart';
import 'router_config.dart';
import 'utils/locale_setup.dart' as custom_locale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  custom_locale.initializeLocaleService(); // Initialize locale service
  custom_locale.setupTranslations(); // Set up translations
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: custom_locale.LocaleService.instance.locale,
      builder: (context, locale, child) {
        return MaterialApp.router(
          routerConfig: routerConfig,
          title: 'Flutter Study',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ko'), // Korean
          ],
          locale: locale, // Dynamically update the locale
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
        );
      },
    );
  }
}
