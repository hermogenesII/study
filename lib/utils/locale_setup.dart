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

  void init({
    required bool deviceLocale,
    required String defaultLocale,
    required String fallbackLocale,
    required bool useKeyAsDefaultText,
  }) {
    LocaleService.instance.setLocale(defaultLocale);
    lo.init(
      deviceLocale: deviceLocale,
      defaultLocale: defaultLocale,
      fallbackLocale: fallbackLocale,
      useKeyAsDefaultText: useKeyAsDefaultText,
    );
  }
}

/// Initializes the locale service with default settings.
/// - `deviceLocale`: Automatically detects the device's locale.
/// - `defaultLocale`: Sets the default locale to English ('en').
/// - `fallbackLocale`: Sets the fallback locale to English ('en').
/// - `useKeyAsDefaultText`: Uses the key as default text if translation is missing.
void initializeLocaleService() {
  LocaleService.instance.init(
    deviceLocale: true,
    defaultLocale: 'en',
    fallbackLocale: 'en',
    useKeyAsDefaultText: true,
  );
}

/// Sets up translations for the application.
/// - Adds translations for 'home', 'profile', 'chat', and 'logout' in English and Korean.
void setupTranslations() {
  lo.merge({
    'home': {'en': 'Home', 'ko': '홈'},
    'profile': {'en': 'Profile', 'ko': '프로필'},
    'chat': {'en': 'Chat', 'ko': '채팅'},
    'logout': {'en': 'Logout', 'ko': '로그아웃'},
  });
}
