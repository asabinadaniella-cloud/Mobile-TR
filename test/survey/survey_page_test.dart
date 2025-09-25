import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tochka_rosta/core/localization/l10n.dart';
import 'package:tochka_rosta/features/survey/data/models/survey_models.dart';
import 'package:tochka_rosta/features/survey/domain/survey_repository.dart';
import 'package:tochka_rosta/features/survey/presentation/controllers/survey_controller.dart';
import 'package:tochka_rosta/features/survey/presentation/controllers/survey_sync_service.dart';
import 'package:tochka_rosta/features/survey/presentation/pages/survey_page.dart';

class FakeSurveyRepository implements SurveyRepository {
  FakeSurveyRepository(this._survey);

  final SurveyVersionModel _survey;
  final Map<String, dynamic> savedAnswers = {};

  @override
  Future<SurveyVersionModel> fetchActiveSurvey({bool forceRefresh = false}) async {
    return _survey;
  }

  @override
  Future<Map<String, dynamic>> loadSavedAnswers(
    String surveyVersionId,
    String userId,
  ) async {
    return Map<String, dynamic>.from(savedAnswers);
  }

  @override
  Future<void> saveAnswer({
    required String surveyVersionId,
    required String questionId,
    required String userId,
    required dynamic answer,
    DateTime? answeredAt,
  }) async {
    savedAnswers[questionId] = answer;
  }

  @override
  Future<List<SurveyAnswerPayload>> pendingAnswers(String userId) async => [];

  @override
  Future<void> markAnswerSynced(String responseId) async {}

  @override
  Future<SurveyProgressModel> getProgress(
    String surveyVersionId,
    String userId,
  ) async {
    return SurveyProgressModel(
      totalQuestions: _survey.sections.fold<int>(
        0,
        (previousValue, element) => previousValue + element.questions.length,
      ),
      answeredQuestions: savedAnswers.length,
    );
  }
}

SurveyVersionModel _buildSurvey(SurveyQuestionModel question) {
  return SurveyVersionModel(
    id: 'survey',
    versionNumber: 1,
    title: 'Анкета',
    isActive: true,
    sections: [
      SurveySectionModel(
        id: 'section',
        versionId: 'survey',
        title: 'Блок 1',
        description: 'Описание блока',
        position: 0,
        timeLimitSeconds: 300,
        questions: [question],
      ),
    ],
  );
}

void main() {
  testWidgets('renders scale question and saves changes', (tester) async {
    final question = SurveyQuestionModel(
      id: 'q1',
      sectionId: 'section',
      versionId: 'survey',
      type: SurveyQuestionType.scale,
      text: 'Оцените от 0 до 10',
      position: 0,
      scaleMin: 0,
      scaleMax: 10,
    );
    final repository = FakeSurveyRepository(_buildSurvey(question));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          surveyRepositoryProvider.overrideWithValue(repository),
          surveySyncServiceProvider.overrideWithValue(null),
          firebaseAnalyticsProvider.overrideWithValue(null),
          surveyUserIdProvider.overrideWithValue('tester'),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SurveyPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Slider), findsOneWidget);
    await tester.drag(find.byType(Slider), const Offset(200, 0));
    await tester.pumpAndSettle();

    expect(repository.savedAnswers['q1'], isNotNull);
  });

  testWidgets('renders checkbox question and toggles options', (tester) async {
    final question = SurveyQuestionModel(
      id: 'q1',
      sectionId: 'section',
      versionId: 'survey',
      type: SurveyQuestionType.checkbox,
      text: 'Выберите варианты',
      position: 0,
      options: const [
        SurveyOptionModel(id: 'o1', value: 'o1', label: 'Первый', position: 0),
        SurveyOptionModel(id: 'o2', value: 'o2', label: 'Второй', position: 1),
      ],
    );
    final repository = FakeSurveyRepository(_buildSurvey(question));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          surveyRepositoryProvider.overrideWithValue(repository),
          surveySyncServiceProvider.overrideWithValue(null),
          firebaseAnalyticsProvider.overrideWithValue(null),
          surveyUserIdProvider.overrideWithValue('tester'),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SurveyPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Первый'));
    await tester.pumpAndSettle();

    expect(repository.savedAnswers['q1'], contains('o1'));
  });

  testWidgets('shows validation error for required question', (tester) async {
    final question = SurveyQuestionModel(
      id: 'q1',
      sectionId: 'section',
      versionId: 'survey',
      type: SurveyQuestionType.text,
      text: 'Расскажите о себе',
      isRequired: true,
      position: 0,
    );
    final repository = FakeSurveyRepository(_buildSurvey(question));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          surveyRepositoryProvider.overrideWithValue(repository),
          surveySyncServiceProvider.overrideWithValue(null),
          firebaseAnalyticsProvider.overrideWithValue(null),
          surveyUserIdProvider.overrideWithValue('tester'),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SurveyPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();

    expect(find.text('Пожалуйста, ответьте на вопрос.'), findsOneWidget);
  });
}
