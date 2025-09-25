import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';

class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  static const routeName = 'survey';
  static const routePath = '/survey';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.surveyTitle)),
      body: const Center(
        child: Text('Конструктор опросов находится в разработке.'),
      ),
    );
  }
}
