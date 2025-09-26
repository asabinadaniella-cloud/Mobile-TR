import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/models/survey_models.dart';
import '../../domain/survey_repository.dart';
import '../../data/repositories/survey_repository_impl.dart';
import 'survey_sync_service.dart';

class SurveyState {
  const SurveyState({
    required this.survey,
    required this.currentSectionIndex,
    required this.currentQuestionIndex,
    required this.answers,
    required this.remainingTime,
    this.isSaving = false,
    this.validationError,
  });

  factory SurveyState.initial() => SurveyState(
        survey: const AsyncValue.loading(),
        currentSectionIndex: 0,
        currentQuestionIndex: 0,
        answers: const {},
        remainingTime: Duration.zero,
      );

  final AsyncValue<SurveyVersionModel> survey;
  final int currentSectionIndex;
  final int currentQuestionIndex;
  final Map<String, dynamic> answers;
  final Duration remainingTime;
  final bool isSaving;
  final String? validationError;

  SurveyQuestionModel? get currentQuestion {
    final version = survey.valueOrNull;
    if (version == null) return null;
    if (currentSectionIndex >= version.sections.length) return null;
    final section = version.sections[currentSectionIndex];
    if (currentQuestionIndex >= section.questions.length) return null;
    return section.questions[currentQuestionIndex];
  }

  SurveySectionModel? get currentSection {
    final version = survey.valueOrNull;
    if (version == null) return null;
    if (currentSectionIndex >= version.sections.length) return null;
    return version.sections[currentSectionIndex];
  }

  int get totalQuestions {
    final version = survey.valueOrNull;
    if (version == null) return 0;
    return version.sections.fold<int>(
      0,
      (previousValue, element) => previousValue + element.questions.length,
    );
  }

  int get answeredQuestions => answers.length;

  double get progress {
    final total = totalQuestions;
    if (total == 0) {
      return 0;
    }
    return answeredQuestions / total;
  }

  SurveyState copyWith({
    AsyncValue<SurveyVersionModel>? survey,
    int? currentSectionIndex,
    int? currentQuestionIndex,
    Map<String, dynamic>? answers,
    Duration? remainingTime,
    bool? isSaving,
    String? validationError,
    bool clearValidationError = false,
  }) {
    return SurveyState(
      survey: survey ?? this.survey,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      remainingTime: remainingTime ?? this.remainingTime,
      isSaving: isSaving ?? this.isSaving,
      validationError: clearValidationError ? null : validationError ?? this.validationError,
    );
  }
}

class SurveyController extends StateNotifier<SurveyState> {
  static const missingAnswerErrorKey = 'missing_answer';

  SurveyController(
    this._repository,
    this._syncService,
    this._analytics,
    this._userId,
  ) : super(SurveyState.initial());

  final SurveyRepository _repository;
  final SurveySyncService? _syncService;
  final FirebaseAnalytics? _analytics;
  final String _userId;

  Timer? _timer;

  Future<void> loadSurvey() async {
    state = state.copyWith(survey: const AsyncValue.loading());
    try {
      final survey = await _repository.fetchActiveSurvey();
      final savedAnswers = await _repository.loadSavedAnswers(survey.id, _userId);

      if (survey.sections.isEmpty) {
        state = state.copyWith(
          survey: AsyncValue.data(survey),
          answers: Map<String, dynamic>.from(savedAnswers),
          currentSectionIndex: 0,
          currentQuestionIndex: 0,
          remainingTime: Duration.zero,
          clearValidationError: true,
        );
        await _analytics?.logEvent(name: 'survey_start', parameters: {'survey_id': survey.id});
        unawaited(_syncService?.syncPendingResponses(_userId));
        return;
      }

      var sectionIndex = 0;
      var questionIndex = 0;
      bool located = false;
      for (var i = 0; i < survey.sections.length; i++) {
        final section = survey.sections[i];
        if (section.questions.isEmpty) {
          continue;
        }
        for (var j = 0; j < section.questions.length; j++) {
          final question = section.questions[j];
          if (!savedAnswers.containsKey(question.id)) {
            sectionIndex = i;
            questionIndex = j;
            located = true;
            break;
          }
        }
        if (located) {
          break;
        }
      }

      if (!located) {
        for (var i = survey.sections.length - 1; i >= 0; i--) {
          final section = survey.sections[i];
          if (section.questions.isNotEmpty) {
            sectionIndex = i;
            questionIndex = section.questions.length - 1;
            break;
          }
        }
      }

      final targetSection = survey.sections[sectionIndex];
      state = state.copyWith(
        survey: AsyncValue.data(survey),
        answers: Map<String, dynamic>.from(savedAnswers),
        currentSectionIndex: sectionIndex,
        currentQuestionIndex: questionIndex,
        remainingTime: _initialSectionDuration(targetSection),
        clearValidationError: true,
      );
      _startTimer();
      await _analytics?.logEvent(name: 'survey_start', parameters: {'survey_id': survey.id});
      unawaited(_syncService?.syncPendingResponses(_userId));
    } catch (error, stackTrace) {
      state = state.copyWith(survey: AsyncValue.error(error, stackTrace));
    }
  }

  Future<void> saveAnswer(dynamic answer) async {
    final survey = state.survey.valueOrNull;
    final question = state.currentQuestion;
    final section = state.currentSection;
    if (survey == null || question == null || section == null) {
      return;
    }
    state = state.copyWith(isSaving: true, clearValidationError: true);
    final updatedAnswers = Map<String, dynamic>.from(state.answers)
      ..[question.id] = answer;
    try {
      await _repository.saveAnswer(
        surveyVersionId: survey.id,
        questionId: question.id,
        userId: _userId,
        answer: answer,
      );
      state = state.copyWith(
        isSaving: false,
        answers: updatedAnswers,
        clearValidationError: true,
      );
      await _analytics?.logEvent(
        name: 'survey_answer_saved',
        parameters: {
          'survey_id': survey.id,
          'section_id': section.id,
          'question_id': question.id,
          'question_type': question.type.name,
        },
      );
      unawaited(_syncService?.syncPendingResponses(_userId));
    } catch (error) {
      updatedAnswers.remove(question.id);
      state = state.copyWith(isSaving: false, answers: state.answers);
      rethrow;
    }
  }

  Future<void> nextQuestion({bool triggeredByTimer = false}) async {
    final survey = state.survey.valueOrNull;
    final section = state.currentSection;
    final question = state.currentQuestion;
    if (survey == null || section == null || question == null) {
      return;
    }

    if (!triggeredByTimer && !_hasAnswer(question)) {
      await _analytics?.logEvent(
        name: 'survey_validation_error',
        parameters: {
          'survey_id': survey.id,
          'section_id': section.id,
          'question_id': question.id,
          'reason': 'missing_answer',
        },
      );
      state = state.copyWith(validationError: missingAnswerErrorKey);
      return;
    }

    if (triggeredByTimer) {
      await _analytics?.logEvent(
        name: 'survey_auto_advance',
        parameters: {
          'survey_id': survey.id,
          'section_id': section.id,
          'question_id': question.id,
        },
      );
    }

    final isLastQuestionInSection =
        state.currentQuestionIndex >= section.questions.length - 1;
    final isLastSection = state.currentSectionIndex >= survey.sections.length - 1;
    final isLastQuestionInSurvey =
        isLastQuestionInSection && isLastSection;

    if (isLastQuestionInSurvey) {
      await _analytics?.logEvent(
        name: 'survey_complete',
        parameters: {
          'survey_id': survey.id,
          'section_id': section.id,
          'question_id': question.id,
          'trigger': triggeredByTimer ? 'timer' : 'user',
        },
      );
      _timer?.cancel();
      state = state.copyWith(validationError: null);
      return;
    }

    if (isLastQuestionInSection) {
      await _analytics?.logEvent(
        name: 'survey_section_complete',
        parameters: {
          'survey_id': survey.id,
          'section_id': section.id,
          'question_id': question.id,
          'trigger': triggeredByTimer ? 'timer' : 'user',
        },
      );
      final nextSectionIndex = state.currentSectionIndex + 1;
      if (nextSectionIndex < survey.sections.length) {
        state = state.copyWith(
          currentSectionIndex: nextSectionIndex,
          currentQuestionIndex: 0,
          validationError: null,
          remainingTime: _initialSectionDuration(survey.sections[nextSectionIndex]),
        );
        _startTimer();
      }
    } else {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        validationError: null,
      );
    }
  }

  void previousQuestion() {
    final survey = state.survey.valueOrNull;
    if (survey == null) return;
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
        validationError: null,
      );
      return;
    }
    if (state.currentSectionIndex > 0) {
      final prevSectionIndex = state.currentSectionIndex - 1;
      final prevSection = survey.sections[prevSectionIndex];
      state = state.copyWith(
        currentSectionIndex: prevSectionIndex,
        currentQuestionIndex: prevSection.questions.length - 1,
        remainingTime: _initialSectionDuration(prevSection),
        validationError: null,
      );
      _startTimer();
    }
  }

  Future<void> continueLater() async {
    final survey = state.survey.valueOrNull;
    final question = state.currentQuestion;
    if (survey != null) {
      await _analytics?.logEvent(
        name: 'survey_paused',
        parameters: {
          'survey_id': survey.id,
          if (question != null) 'question_id': question.id,
        },
      );
    }
    _timer?.cancel();
    await _syncService?.syncPendingResponses(_userId);
  }

  void disposeController() {
    _timer?.cancel();
  }

  bool _hasAnswer(SurveyQuestionModel question) {
    final answer = state.answers[question.id];
    if (answer == null) {
      return false;
    }
    switch (question.type) {
      case SurveyQuestionType.checkbox:
        return answer is Iterable && answer.isNotEmpty;
      case SurveyQuestionType.text:
        return answer is String && answer.trim().isNotEmpty;
      default:
        return true;
    }
  }

  Duration _initialSectionDuration(SurveySectionModel section) {
    final seconds = section.timeLimitSeconds ?? 180;
    return Duration(seconds: seconds);
  }

  void _startTimer() {
    _timer?.cancel();
    final section = state.currentSection;
    if (section == null) {
      return;
    }
    var remaining = section.timeLimitSeconds ?? 180;
    state = state.copyWith(remainingTime: Duration(seconds: remaining));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= 1;
      if (remaining <= 0) {
        timer.cancel();
        unawaited(nextQuestion(triggeredByTimer: true));
      } else {
        state = state.copyWith(remainingTime: Duration(seconds: remaining));
      }
    });
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}

final surveyUserIdProvider = Provider<String>((ref) => 'local-user');

final surveyControllerProvider =
    StateNotifierProvider<SurveyController, SurveyState>((ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  final syncService = ref.watch(surveySyncServiceProvider);
  final analytics = ref.watch(firebaseAnalyticsProvider);
  final userId = ref.watch(surveyUserIdProvider);
  final controller = SurveyController(repository, syncService, analytics, userId);
  ref.onDispose(controller.disposeController);
  unawaited(controller.loadSurvey());
  return controller;
});
