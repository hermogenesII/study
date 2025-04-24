import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

/// LocaleService with ValueNotifier to notify listeners of locale changes.
class LocaleService {
  static final LocaleService instance = LocaleService._internal();

  final ValueNotifier<Locale> locale = ValueNotifier(Locale('en'));

  LocaleService._internal();

  void setLocale(String localeCode) {
    locale.value = Locale(localeCode);
    lo.setLocale(localeCode);
  }
}

void setupTranslations() {
  lo.merge({
    'home': {'en': 'Home', 'ko': '홈'},
    'profile': {'en': 'Profile', 'ko': '프로필'},
    'chat': {'en': 'Chat', 'ko': '채팅'},
    'logout': {'en': 'Logout', 'ko': '로그아웃'},
  });
}
