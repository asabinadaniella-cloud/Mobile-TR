import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/providers/app_providers.dart';
import '../../domain/survey_repository.dart';
import '../models/survey_models.dart';

class SurveyLocalDataSource {
  SurveyLocalDataSource(this._db);

  final AppDatabase _db;

  Future<void> cacheSurvey(SurveyVersionModel survey) async {
    await _db.transaction(() async {
      await _db.update(_db.surveyVersions).write(
            const SurveyVersionsCompanion(isActive: Value(false)),
          );
      await _db.surveyVersionsDao.upsertSurveyVersion(
        SurveyVersionsCompanion(
          id: Value(survey.id),
          versionNumber: Value(survey.versionNumber),
          title: Value(survey.title),
          description: Value(survey.description),
          isActive: const Value(true),
        ),
      );

      for (final section in survey.sections) {
        await _db.surveySectionsDao.upsertSection(
          SurveySectionsCompanion(
            id: Value(section.id),
            surveyVersionId: Value(section.versionId),
            title: Value(section.title),
            description: Value(section.description),
            position: Value(section.position),
          ),
        );

        for (final question in section.questions) {
          await _db.questionsDao.upsertQuestion(
            QuestionsCompanion(
              id: Value(question.id),
              surveySectionId: Value(question.sectionId),
              surveyVersionId: Value(question.versionId),
              questionType: Value(question.type.asJson),
              text: Value(question.text),
              helpText: Value(question.helpText),
              isRequired: Value(question.isRequired),
              position: Value(question.position),
              validationRules: Value(
                jsonEncode({
                  'scale_min': question.scaleMin,
                  'scale_max': question.scaleMax,
                }),
              ),
            ),
          );

          for (final option in question.options) {
            await _db.questionOptionsDao.upsertOption(
              QuestionOptionsCompanion(
                id: Value(option.id),
                questionId: Value(question.id),
                value: Value(option.value),
                label: Value(option.label),
                position: Value(option.position),
                isDefault: Value(option.isDefault),
              ),
            );
          }
        }
      }
    });
  }

  Future<SurveyVersionModel?> readActiveSurvey() async {
    final version = await _db.surveyVersionsDao.getActiveVersion();
    if (version == null) {
      return null;
    }
    return _mapSurveyVersion(version);
  }

  Future<SurveyVersionModel?> readSurveyById(String versionId) async {
    final query = await (_db.select(_db.surveyVersions)
          ..where((tbl) => tbl.id.equals(versionId)))
        .getSingleOrNull();
    if (query == null) {
      return null;
    }
    return _mapSurveyVersion(query);
  }

  Future<Map<String, dynamic>> loadSavedAnswers(
    String surveyVersionId,
    String userId,
  ) async {
    final responses = await (_db.select(_db.responses)
          ..where(
            (tbl) =>
                tbl.surveyVersionId.equals(surveyVersionId) &
                tbl.userId.equals(userId),
          ))
        .get();
    final answers = <String, dynamic>{};
    for (final response in responses) {
      try {
        answers[response.questionId] = jsonDecode(response.answer);
      } catch (_) {
        answers[response.questionId] = response.answer;
      }
    }
    return answers;
  }

  Future<void> saveAnswer({
    required String surveyVersionId,
    required String questionId,
    required String userId,
    required dynamic answer,
    DateTime? answeredAt,
  }) async {
    await _ensureUser(userId);
    await _db.responsesDao.upsertResponse(
      ResponsesCompanion(
        id: Value('$userId-$questionId'),
        questionId: Value(questionId),
        userId: Value(userId),
        surveyVersionId: Value(surveyVersionId),
        answer: Value(jsonEncode(answer)),
        answeredAt: Value(answeredAt ?? DateTime.now()),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<SurveyAnswerPayload>> pendingAnswers(String userId) async {
    final pending = await (_db.select(_db.responses)
          ..where(
            (tbl) => tbl.userId.equals(userId) & tbl.isSynced.equals(false),
          ))
        .get();
    return pending
        .map(
          (response) => SurveyAnswerPayload(
            id: response.id,
            questionId: response.questionId,
            surveyVersionId: response.surveyVersionId,
            userId: response.userId,
            answer: response.answer,
            answeredAt: response.answeredAt,
            isSynced: response.isSynced,
          ),
        )
        .toList();
  }

  Future<void> markAnswerSynced(String responseId) async {
    await (_db.update(_db.responses)..where((tbl) => tbl.id.equals(responseId))).write(
      ResponsesCompanion(
        isSynced: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<SurveyProgressModel> getProgress(
    String surveyVersionId,
    String userId,
  ) async {
    final progress = await _db.responsesDao.getSurveyProgress(
      surveyVersionId,
      userId,
    );
    return SurveyProgressModel(
      totalQuestions: progress.totalQuestions,
      answeredQuestions: progress.answeredQuestions,
    );
  }

  Future<SurveyVersionModel> _mapSurveyVersion(SurveyVersion version) async {
    final sections = await _db.surveySectionsDao.sectionsByVersion(version.id);
    final questions = await _db.questionsDao.questionsForVersion(version.id);

    final sectionModels = <SurveySectionModel>[];
    for (final section in sections..sort((a, b) => a.position.compareTo(b.position))) {
      final sectionQuestions = questions
          .where((q) => q.surveySectionId == section.id)
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position));
      final questionModels = <SurveyQuestionModel>[];

      for (final question in sectionQuestions) {
        final optionEntities = await _db.questionOptionsDao.optionsForQuestion(question.id);
        final options = optionEntities
            .map(
              (option) => SurveyOptionModel(
                id: option.id,
                value: option.value,
                label: option.label,
                position: option.position,
                isDefault: option.isDefault,
              ),
            )
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position));

        final validation = _parseValidation(question.validationRules);
        questionModels.add(
          SurveyQuestionModel(
            id: question.id,
            sectionId: question.surveySectionId,
            versionId: question.surveyVersionId,
            type: SurveyQuestionType.fromJson(question.questionType),
            text: question.text,
            helpText: question.helpText,
            isRequired: question.isRequired,
            position: question.position,
            options: options,
            scaleMin: validation['scale_min'] as int? ?? 0,
            scaleMax: validation['scale_max'] as int? ?? 10,
          ),
        );
      }

      sectionModels.add(
        SurveySectionModel(
          id: section.id,
          versionId: section.surveyVersionId,
          title: section.title,
          description: section.description,
          position: section.position,
          timeLimitSeconds: 180,
          questions: questionModels,
        ),
      );
    }

    return SurveyVersionModel(
      id: version.id,
      versionNumber: version.versionNumber,
      title: version.title,
      description: version.description,
      isActive: version.isActive,
      sections: sectionModels,
    );
  }

  Map<String, dynamic> _parseValidation(String? json) {
    if (json == null || json.isEmpty) {
      return {};
    }
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry('$key', value));
      }
    } catch (_) {
      // ignore parsing errors and return empty config
    }
    return {};
  }

  Future<void> _ensureUser(String userId) async {
    final existing = await _db.usersDao.fetchUser(userId);
    if (existing != null) {
      return;
    }
    await _db.usersDao.createOrUpdateUser(
      UsersCompanion(
        id: Value(userId),
        status: const Value('active'),
      ),
    );
  }
}

final surveyLocalDataSourceProvider = Provider<SurveyLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SurveyLocalDataSource(db);
});
