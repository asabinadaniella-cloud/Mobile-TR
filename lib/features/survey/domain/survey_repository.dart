import '../data/models/survey_models.dart';

class SurveyProgressModel {
  const SurveyProgressModel({
    required this.totalQuestions,
    required this.answeredQuestions,
  });

  final int totalQuestions;
  final int answeredQuestions;

  double get completionRate {
    if (totalQuestions == 0) {
      return 0;
    }
    return answeredQuestions / totalQuestions;
  }
}

abstract class SurveyRepository {
  Future<SurveyVersionModel> fetchActiveSurvey({bool forceRefresh = false});

  Future<Map<String, dynamic>> loadSavedAnswers(
    String surveyVersionId,
    String userId,
  );

  Future<void> saveAnswer({
    required String surveyVersionId,
    required String questionId,
    required String userId,
    required dynamic answer,
    DateTime? answeredAt,
  });

  Future<List<SurveyAnswerPayload>> pendingAnswers(String userId);

  Future<void> markAnswerSynced(String responseId);

  Future<SurveyProgressModel> getProgress(
    String surveyVersionId,
    String userId,
  );
}
