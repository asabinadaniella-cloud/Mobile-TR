import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static const routeName = 'chat';
  static const routePath = '/chat';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      body: const Center(
        child: Text('Коммуникации с наставниками появятся в этом разделе.'),
      ),
    );
  }
}
