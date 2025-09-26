import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/providers/app_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const routeName = 'settings';
  static const routePath = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final textScale = ref.watch(textScaleFactorProvider);
    final locale = ref.watch(localeProvider);
    final analytics = ref.read(firebaseAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.settingsThemeLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(l10n.settingsThemeSystem)),
              ButtonSegment(value: ThemeMode.light, label: Text(l10n.settingsThemeLight)),
              ButtonSegment(value: ThemeMode.dark, label: Text(l10n.settingsThemeDark)),
            ],
            selected: {themeMode},
            onSelectionChanged: (value) {
              final newMode = value.first;
              ref.read(themeModeProvider.notifier).state = newMode;
              analytics?.logEvent(
                name: 'settings_theme_changed',
                parameters: {'theme_mode': newMode.name},
              );
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.settingsTextSizeLabel, style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: textScale,
            min: 0.8,
            max: 1.4,
            divisions: 6,
            label: textScale.toStringAsFixed(1),
            onChanged: (value) {
              ref.read(textScaleFactorProvider.notifier).state = value;
              analytics?.logEvent(
                name: 'settings_text_scale_changed',
                parameters: {'scale': value},
              );
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.settingsLanguageLabel, style: Theme.of(context).textTheme.titleMedium),
          DropdownButton<Locale>(
            value: locale,
            items: [
              DropdownMenuItem(value: const Locale('ru'), child: Text(l10n.settingsLanguageRu)),
              DropdownMenuItem(value: const Locale('en'), child: Text(l10n.settingsLanguageEn)),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).state = value;
                analytics?.logEvent(
                  name: 'settings_language_changed',
                  parameters: {'language_code': value.languageCode},
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
