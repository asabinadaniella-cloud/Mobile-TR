import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';
import '../controllers/survey_controller.dart';
import '../widgets/survey_question_card.dart';

class SurveyPage extends ConsumerWidget {
  const SurveyPage({super.key});

  static const routeName = 'survey';
  static const routePath = '/survey';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyControllerProvider);
    final controller = ref.read(surveyControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.survey.valueOrNull?.title ?? l10n.surveyTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _TimerBadge(remaining: state.remainingTime),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: state.survey.when(
            data: (survey) {
              final section = state.currentSection;
              final question = state.currentQuestion;
              if (survey.sections.isEmpty || section == null || question == null) {
                return Center(child: Text(l10n.surveyNoQuestionsMessage));
              }

              final validationMessage = state.validationError == null
                  ? null
                  : state.validationError == SurveyController.missingAnswerErrorKey
                      ? l10n.surveyValidationRequired
                      : state.validationError!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (section.description != null && section.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(section.description!),
                    ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: state.progress),
                  const SizedBox(height: 8),
                  Text(
                    '${state.answeredQuestions}/${state.totalQuestions} ${l10n.surveyQuestionsLabel}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SurveyQuestionCard(
                            question: question,
                            answer: state.answers[question.id],
                            onChanged: (value) {
                              controller.saveAnswer(value);
                            },
                          ),
                          if (validationMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                validationMessage,
                                style: TextStyle(color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          await controller.continueLater();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(l10n.surveyContinueLater),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: state.currentSectionIndex == 0 && state.currentQuestionIndex == 0
                            ? null
                            : controller.previousQuestion,
                        child: Text(l10n.surveyBackButton),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: state.isSaving
                            ? null
                            : () {
                                controller.nextQuestion();
                              },
                        child: state.isSaving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.surveyNextButton),
                      ),
                    ],
                  ),
                ],
              );
            },
            error: (error, _) => _ErrorState(
              l10n: l10n,
              message: error.toString(),
              onRetry: controller.loadSurvey,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.l10n, required this.message, required this.onRetry});

  final AppLocalizations l10n;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.surveyLoadErrorTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.surveyRetryButton),
          ),
        ],
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$minutes:$seconds'),
    );
  }
}
