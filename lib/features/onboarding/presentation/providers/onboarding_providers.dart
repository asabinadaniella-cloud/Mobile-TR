import 'package:riverpod/riverpod.dart';

import '../../data/onboarding_local_datasource.dart';
import '../../domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<void> completeOnboarding() => _localDataSource.cacheOnboardingComplete();
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final dataSource = ref.read(onboardingLocalDataSourceProvider);
  return OnboardingRepositoryImpl(dataSource);
});

final onboardingCompletionController = FutureProvider<void>((ref) async {
  final repository = ref.read(onboardingRepositoryProvider);
  await repository.completeOnboarding();
});
