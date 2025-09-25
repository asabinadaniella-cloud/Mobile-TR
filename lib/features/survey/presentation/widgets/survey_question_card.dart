import 'package:flutter/material.dart';

import '../../data/models/survey_models.dart';

class SurveyQuestionCard extends StatelessWidget {
  const SurveyQuestionCard({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
  });

  final SurveyQuestionModel question;
  final dynamic answer;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (question.helpText != null && question.helpText!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                question.helpText!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            _buildQuestionBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionBody() {
    switch (question.type) {
      case SurveyQuestionType.scale:
        return _ScaleQuestion(
          question: question,
          answer: answer is int ? answer as int : question.scaleMin,
          onChanged: (value) => onChanged(value),
        );
      case SurveyQuestionType.checkbox:
        final selectedValues = <String>{};
        if (answer is Iterable) {
          for (final item in answer as Iterable<dynamic>) {
            selectedValues.add(item.toString());
          }
        }
        return Column(
          children: [
            for (final option in question.options)
              CheckboxListTile(
                value: selectedValues.contains(option.value),
                title: Text(option.label),
                onChanged: (isChecked) {
                  final updated = <String>{...selectedValues};
                  if (isChecked ?? false) {
                    updated.add(option.value);
                  } else {
                    updated.remove(option.value);
                  }
                  onChanged(updated.toList());
                },
              ),
          ],
        );
      case SurveyQuestionType.radio:
        final selected = answer?.toString();
        return Column(
          children: [
            for (final option in question.options)
              RadioListTile<String>(
                value: option.value,
                groupValue: selected,
                title: Text(option.label),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
          ],
        );
      case SurveyQuestionType.text:
        return TextFormField(
          key: ValueKey(question.id),
          initialValue: answer is String ? answer as String : '',
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
        );
    }
  }
}

class _ScaleQuestion extends StatefulWidget {
  const _ScaleQuestion({
    required this.question,
    required this.answer,
    required this.onChanged,
  });

  final SurveyQuestionModel question;
  final int answer;
  final ValueChanged<int> onChanged;

  @override
  State<_ScaleQuestion> createState() => _ScaleQuestionState();
}

class _ScaleQuestionState extends State<_ScaleQuestion> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.answer.toDouble();
  }

  @override
  void didUpdateWidget(covariant _ScaleQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      _value = widget.answer.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final min = widget.question.scaleMin.toDouble();
    final max = widget.question.scaleMax.toDouble();
    final divisions = (max - min).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          value: _value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions > 0 ? divisions : null,
          label: _value.round().toString(),
          onChanged: (value) {
            setState(() {
              _value = value;
            });
            widget.onChanged(value.round());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(min.toInt().toString()),
            Text(max.toInt().toString()),
          ],
        ),
      ],
    );
  }
}
