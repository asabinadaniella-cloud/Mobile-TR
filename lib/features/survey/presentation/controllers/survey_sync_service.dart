import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/survey_remote_data_source.dart';
import '../../data/models/survey_models.dart';
import '../../domain/survey_repository.dart';
import '../../data/repositories/survey_repository_impl.dart';

class SurveySyncService {
  SurveySyncService(this._repository, this._remoteDataSource);

  final SurveyRepository _repository;
  final SurveyRemoteDataSource _remoteDataSource;

  Future<void> syncPendingResponses(String userId) async {
    final pending = await _repository.pendingAnswers(userId);
    for (final response in pending) {
      await _syncWithBackoff(response);
    }
  }

  Future<void> _syncWithBackoff(SurveyAnswerPayload response) async {
    const maxAttempts = 5;
    var attempt = 0;
    var delay = const Duration(milliseconds: 500);

    while (attempt < maxAttempts) {
      try {
        await _remoteDataSource.submitResponse(response);
        await _repository.markAnswerSynced(response.id);
        return;
      } catch (_) {
        attempt += 1;
        if (attempt >= maxAttempts) {
          return;
        }
        await Future<void>.delayed(delay);
        final nextDelay = delay * 2;
        delay = nextDelay > const Duration(seconds: 30)
            ? const Duration(seconds: 30)
            : nextDelay;
      }
    }
  }
}

final surveySyncServiceProvider = Provider<SurveySyncService?>((ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  final remote = ref.watch(surveyRemoteDataSourceProvider);
  return SurveySyncService(repository, remote);
});
