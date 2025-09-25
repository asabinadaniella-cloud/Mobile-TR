import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  static const routeName = 'results';
  static const routePath = '/results';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultsTitle)),
      body: const Center(
        child: Text('Аналитика по результатам будет представлена здесь.'),
      ),
    );
  }
}
