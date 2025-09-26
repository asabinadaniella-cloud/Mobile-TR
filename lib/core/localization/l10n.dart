import 'dart:async';
import 'dart:collection';
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
    final codes = LinkedHashSet<String>()
      ..add('ru')
      ..add(locale.languageCode.toLowerCase());
    final merged = <String, String>{};

    for (final code in codes) {
      try {
        final jsonString = await rootBundle.loadString('assets/translations/intl_${code.toLowerCase()}.arb');
        final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        jsonMap.forEach((key, value) {
          if (key.startsWith('@')) {
            return;
          }
          if (value is! String) {
            return;
          }
          if (value.isEmpty) {
            merged.putIfAbsent(key, () => value);
            return;
          }
          merged[key] = value;
        });
      } catch (_) {
        continue;
      }
    }

    if (merged.isEmpty) {
      merged['appTitle'] = defaultTitle;
    }

    _localizedStrings = merged;
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
  String get chatModeUser => _get('chatModeUser');
  String get chatModeModerator => _get('chatModeModerator');
  String get chatModeratorChatPickerLabel => _get('chatModeratorChatPickerLabel');
  String get chatMarkInWork => _get('chatMarkInWork');
  String get chatModeratorTyping => _get('chatModeratorTyping');
  String get chatEmptyUser => _get('chatEmptyUser');
  String get chatEmptyModerator => _get('chatEmptyModerator');
  String get chatHistoryEnd => _get('chatHistoryEnd');
  String get chatAttachTooltip => _get('chatAttachTooltip');
  String get chatInputHint => _get('chatInputHint');
  String get chatSend => _get('chatSend');
  String get chatAuthorModerator => _get('chatAuthorModerator');
  String get chatAuthorUser => _get('chatAuthorUser');
  String get chatMessagePending => _get('chatMessagePending');
  String get resultsEmptyState => _get('resultsEmptyState');
  String get resultsStatusInReview => _get('resultsStatusInReview');
  String get resultsStatusReady => _get('resultsStatusReady');
  String get resultsCreatedAt => _get('resultsCreatedAt');
  String get resultsUpdatedAt => _get('resultsUpdatedAt');
  String get resultsSummaryTitle => _get('resultsSummaryTitle');
  String get resultsRecommendationsTitle => _get('resultsRecommendationsTitle');
  String get resultsRecommendationsEmpty => _get('resultsRecommendationsEmpty');
  String get resultsExportCsv => _get('resultsExportCsv');
  String get resultsDownloadPdf => _get('resultsDownloadPdf');
  String get resultsModeratorSectionTitle => _get('resultsModeratorSectionTitle');
  String get resultsSummaryEditorHint => _get('resultsSummaryEditorHint');
  String get resultsSummaryDraftNotice => _get('resultsSummaryDraftNotice');
  String get resultsPublishAction => _get('resultsPublishAction');
  String get resultsPublishSuccessMessage => _get('resultsPublishSuccessMessage');
  String get resultsExportPreparing => _get('resultsExportPreparing');
  String get resultsNotFoundMessage => _get('resultsNotFoundMessage');
  String get onboardingDescription => _get('onboardingDescription');
  String get continueAction => _get('continueAction');
  String get settingsThemeLabel => _get('settingsThemeLabel');
  String get settingsThemeSystem => _get('settingsThemeSystem');
  String get settingsThemeLight => _get('settingsThemeLight');
  String get settingsThemeDark => _get('settingsThemeDark');
  String get settingsTextSizeLabel => _get('settingsTextSizeLabel');
  String get settingsLanguageLabel => _get('settingsLanguageLabel');
  String get settingsLanguageRu => _get('settingsLanguageRu');
  String get settingsLanguageEn => _get('settingsLanguageEn');
  String get surveyValidationRequired => _get('surveyValidationRequired');
  String get surveyNoQuestionsMessage => _get('surveyNoQuestionsMessage');
  String get surveyQuestionsLabel => _get('surveyQuestionsLabel');
  String get surveyContinueLater => _get('surveyContinueLater');
  String get surveyBackButton => _get('surveyBackButton');
  String get surveyNextButton => _get('surveyNextButton');
  String get surveyLoadErrorTitle => _get('surveyLoadErrorTitle');
  String get surveyRetryButton => _get('surveyRetryButton');
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
