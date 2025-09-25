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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Тема', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('Система')),
              ButtonSegment(value: ThemeMode.light, label: Text('Светлая')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Тёмная')),
            ],
            selected: {themeMode},
            onSelectionChanged: (value) => ref.read(themeModeProvider.notifier).state = value.first,
          ),
          const SizedBox(height: 24),
          Text('Размер текста', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: textScale,
            min: 0.8,
            max: 1.4,
            divisions: 6,
            label: textScale.toStringAsFixed(1),
            onChanged: (value) => ref.read(textScaleFactorProvider.notifier).state = value,
          ),
          const SizedBox(height: 24),
          Text('Язык', style: Theme.of(context).textTheme.titleMedium),
          DropdownButton<Locale>(
            value: locale,
            items: const [
              DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).state = value;
              }
            },
          ),
        ],
      ),
    );
  }
}
