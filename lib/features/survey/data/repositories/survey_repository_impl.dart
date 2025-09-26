import 'package:riverpod/riverpod.dart';

import '../../domain/survey_repository.dart';
import '../datasources/survey_local_data_source.dart';
import '../datasources/survey_remote_data_source.dart';
import '../models/survey_models.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  SurveyRepositoryImpl(this._remote, this._local);

  final SurveyRemoteDataSource _remote;
  final SurveyLocalDataSource _local;
  SurveyVersionModel? _memoryCache;

  @override
  Future<SurveyVersionModel> fetchActiveSurvey({bool forceRefresh = false}) async {
    if (!forceRefresh && _memoryCache != null) {
      return _memoryCache!;
    }

    try {
      final survey = await _remote.fetchActiveSurvey();
      await _local.cacheSurvey(survey);
      _memoryCache = survey;
      return survey;
    } catch (_) {
      final cached = await _local.readActiveSurvey();
      if (cached != null) {
        _memoryCache = cached;
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> loadSavedAnswers(
    String surveyVersionId,
    String userId,
  ) {
    return _local.loadSavedAnswers(surveyVersionId, userId);
  }

  @override
  Future<void> saveAnswer({
    required String surveyVersionId,
    required String questionId,
    required String userId,
    required dynamic answer,
    DateTime? answeredAt,
  }) {
    return _local.saveAnswer(
      surveyVersionId: surveyVersionId,
      questionId: questionId,
      userId: userId,
      answer: answer,
      answeredAt: answeredAt,
    );
  }

  @override
  Future<List<SurveyAnswerPayload>> pendingAnswers(String userId) {
    return _local.pendingAnswers(userId);
  }

  @override
  Future<void> markAnswerSynced(String responseId) {
    return _local.markAnswerSynced(responseId);
  }

  @override
  Future<SurveyProgressModel> getProgress(String surveyVersionId, String userId) {
    return _local.getProgress(surveyVersionId, userId);
  }
}

final surveyRepositoryProvider = Provider<SurveyRepository>((ref) {
  final remote = ref.watch(surveyRemoteDataSourceProvider);
  final local = ref.watch(surveyLocalDataSourceProvider);
  return SurveyRepositoryImpl(remote, local);
});
