import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = 'home';
  static const routePath = '/home';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: const Center(
        child: Text('Контент главной страницы появится позже.'),
      ),
    );
  }
}
