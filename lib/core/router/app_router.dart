import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/l10n.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/results/presentation/models/report_models.dart';
import '../../features/results/presentation/pages/report_view_page.dart';
import '../../features/results/presentation/pages/results_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/survey/presentation/pages/survey_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: OnboardingPage.routePath,
    routes: [
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AuthPage.routePath,
        name: AuthPage.routeName,
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(shell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomePage.routePath,
                name: HomePage.routeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SurveyPage.routePath,
                name: SurveyPage.routeName,
                builder: (context, state) => const SurveyPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ResultsPage.routePath,
                name: ResultsPage.routeName,
                builder: (context, state) => const ResultsPage(),
                routes: [
                  GoRoute(
                    path: ReportViewPage.routePath,
                    name: ReportViewPage.routeName,
                    builder: (context, state) {
                      final extra = state.extra;
                      if (extra is Report) {
                        return ReportViewPage(report: extra);
                      }
                      return const _ReportNotFoundPage();
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ChatPage.routePath,
                name: ChatPage.routeName,
                builder: (context, state) => const ChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                name: ProfilePage.routeName,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: SettingsPage.routePath,
                    name: SettingsPage.routeName,
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: shell.goBranch,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: l10n.homeTitle),
          NavigationDestination(icon: const Icon(Icons.assignment_outlined), label: l10n.surveyTitle),
          NavigationDestination(icon: const Icon(Icons.insights_outlined), label: l10n.resultsTitle),
          NavigationDestination(icon: const Icon(Icons.chat_bubble_outline), label: l10n.chatTitle),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: l10n.profileTitle),
        ],
      ),
    );
  }
}

class _ReportNotFoundPage extends StatelessWidget {
  const _ReportNotFoundPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultsTitle)),
      body: Center(
        child: Text(l10n.resultsNotFoundMessage),
      ),
    );
  }
}
