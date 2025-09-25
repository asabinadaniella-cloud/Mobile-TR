import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const defaultTitle = 'TochkaRosta';

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
  ];

  static Future<AppLocalizations> load(Locale locale) async {
    final canonicalLocale = Intl.canonicalizedLocale(locale.toString());
    final parts = canonicalLocale.split('_');
    final normalizedLocale = Locale(parts.first, parts.length > 1 ? parts[1] : null);
    final localization = AppLocalizations(normalizedLocale);
    await localization._loadTranslations();
    return localization;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('ru'));
  }

  late Map<String, String> _localizedStrings;

  Future<void> _loadTranslations() async {
    final fallbacks = <String>{locale.languageCode, 'ru'};
    for (final code in fallbacks) {
      try {
        final jsonString = await rootBundle.loadString('assets/translations/intl_${code.toLowerCase()}.arb');
        final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
        return;
      } catch (_) {
        continue;
      }
    }
    _localizedStrings = {'appTitle': defaultTitle};
  }

  String _get(String key) {
    return _localizedStrings[key] ?? _localizedStrings['appTitle'] ?? defaultTitle;
  }

  String get appTitle => _get('appTitle');
  String get onboardingTitle => _get('onboardingTitle');
  String get authTitle => _get('authTitle');
  String get homeTitle => _get('homeTitle');
  String get surveyTitle => _get('surveyTitle');
  String get resultsTitle => _get('resultsTitle');
  String get chatTitle => _get('chatTitle');
  String get profileTitle => _get('profileTitle');
  String get settingsTitle => _get('settingsTitle');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
