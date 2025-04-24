import 'package:flutter/material.dart';
import 'package:study/utils/locale_setup.dart' as custom_locale;

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'en') {
          custom_locale.LocaleService.instance.setLocale('en');
        } else if (value == 'ko') {
          custom_locale.LocaleService.instance.setLocale('ko');
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(value: 'en', child: Text('English')),
            PopupMenuItem(value: 'ko', child: Text('Korean')),
          ],
      icon: Icon(Icons.language),
    );
  }
}
