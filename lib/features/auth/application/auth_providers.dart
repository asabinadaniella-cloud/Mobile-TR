import 'package:riverpod/riverpod.dart';

import '../data/auth_repository.dart';
import 'auth_controller.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(ref, repository);
});
