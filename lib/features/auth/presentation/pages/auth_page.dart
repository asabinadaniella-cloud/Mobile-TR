import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../home/presentation/pages/home_page.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  static const routeName = 'auth';
  static const routePath = '/auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.authTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(label: 'Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            const AppTextField(label: 'Пароль', obscureText: true),
            const SizedBox(height: 24),
            AppPrimaryButton(
              onPressed: () => context.go(HomePage.routePath),
              label: 'Войти',
            ),
          ],
        ),
      ),
    );
  }
}
