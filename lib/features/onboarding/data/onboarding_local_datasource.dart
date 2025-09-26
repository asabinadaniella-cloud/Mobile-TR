import 'package:riverpod/riverpod.dart';

class OnboardingLocalDataSource {
  const OnboardingLocalDataSource();

  Future<void> cacheOnboardingComplete() async {
    // TODO: Persist onboarding completion flag locally.
  }
}

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((ref) {
  return const OnboardingLocalDataSource();
});
