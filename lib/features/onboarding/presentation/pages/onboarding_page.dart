import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../providers/onboarding_providers.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  static const routeName = 'onboarding';
  static const routePath = '/onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(firebaseAnalyticsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.onboardingTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(l10n.onboardingDescription),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                final future = analytics?.logEvent(name: 'onboarding_complete');
                if (future != null) {
                  await future;
                }
                await ref.read(onboardingCompletionController.future);
                if (context.mounted) {
                  context.go(AuthPage.routePath);
                }
              },
              child: Text(l10n.continueAction),
            ),
          ],
        ),
      ),
    );
  }
}
