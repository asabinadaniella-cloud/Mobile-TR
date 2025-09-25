import 'dart:convert';

enum SurveyQuestionType { scale, checkbox, radio, text;

  factory SurveyQuestionType.fromJson(String value) {
    switch (value) {
      case 'scale':
        return SurveyQuestionType.scale;
      case 'checkbox':
        return SurveyQuestionType.checkbox;
      case 'radio':
        return SurveyQuestionType.radio;
      case 'text':
        return SurveyQuestionType.text;
      default:
        throw ArgumentError('Unsupported question type: $value');
    }
  }

  String get asJson {
    switch (this) {
      case SurveyQuestionType.scale:
        return 'scale';
      case SurveyQuestionType.checkbox:
        return 'checkbox';
      case SurveyQuestionType.radio:
        return 'radio';
      case SurveyQuestionType.text:
        return 'text';
    }
  }
}

class SurveyOptionModel {
  const SurveyOptionModel({
    required this.id,
    required this.value,
    required this.label,
    required this.position,
    this.isDefault = false,
  });

  factory SurveyOptionModel.fromJson(Map<String, dynamic> json) {
    return SurveyOptionModel(
      id: json['id'] as String,
      value: json['value'] as String,
      label: json['label'] as String,
      position: json['position'] as int? ?? 0,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  final String id;
  final String value;
  final String label;
  final int position;
  final bool isDefault;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'label': label,
      'position': position,
      'is_default': isDefault,
    };
  }
}

class SurveyQuestionModel {
  const SurveyQuestionModel({
    required this.id,
    required this.sectionId,
    required this.versionId,
    required this.type,
    required this.text,
    this.helpText,
    this.isRequired = false,
    this.position = 0,
    this.options = const [],
    this.scaleMin = 0,
    this.scaleMax = 10,
  });

  factory SurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionModel(
      id: json['id'] as String,
      sectionId: json['section_id'] as String,
      versionId: json['version_id'] as String,
      type: SurveyQuestionType.fromJson(json['type'] as String),
      text: json['text'] as String,
      helpText: json['help_text'] as String?,
      isRequired: json['is_required'] as bool? ?? false,
      position: json['position'] as int? ?? 0,
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => SurveyOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      scaleMin: json['scale_min'] as int? ?? 0,
      scaleMax: json['scale_max'] as int? ?? 10,
    );
  }

  final String id;
  final String sectionId;
  final String versionId;
  final SurveyQuestionType type;
  final String text;
  final String? helpText;
  final bool isRequired;
  final int position;
  final List<SurveyOptionModel> options;
  final int scaleMin;
  final int scaleMax;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section_id': sectionId,
      'version_id': versionId,
      'type': type.asJson,
      'text': text,
      'help_text': helpText,
      'is_required': isRequired,
      'position': position,
      'options': options.map((e) => e.toJson()).toList(),
      'scale_min': scaleMin,
      'scale_max': scaleMax,
    };
  }
}

class SurveySectionModel {
  const SurveySectionModel({
    required this.id,
    required this.versionId,
    required this.title,
    this.description,
    this.position = 0,
    this.timeLimitSeconds,
    this.questions = const [],
  });

  factory SurveySectionModel.fromJson(Map<String, dynamic> json) {
    return SurveySectionModel(
      id: json['id'] as String,
      versionId: json['version_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      position: json['position'] as int? ?? 0,
      timeLimitSeconds: json['time_limit_seconds'] as int?,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => SurveyQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String versionId;
  final String title;
  final String? description;
  final int position;
  final int? timeLimitSeconds;
  final List<SurveyQuestionModel> questions;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version_id': versionId,
      'title': title,
      'description': description,
      'position': position,
      'time_limit_seconds': timeLimitSeconds,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

class SurveyVersionModel {
  const SurveyVersionModel({
    required this.id,
    required this.versionNumber,
    required this.title,
    this.description,
    this.isActive = false,
    this.sections = const [],
  });

  factory SurveyVersionModel.fromJson(Map<String, dynamic> json) {
    return SurveyVersionModel(
      id: json['id'] as String,
      versionNumber: json['version'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((e) => SurveySectionModel.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position)),
    );
  }

  final String id;
  final int versionNumber;
  final String title;
  final String? description;
  final bool isActive;
  final List<SurveySectionModel> sections;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': versionNumber,
      'title': title,
      'description': description,
      'is_active': isActive,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}

class SurveyAnswerPayload {
  const SurveyAnswerPayload({
    required this.questionId,
    required this.surveyVersionId,
    required this.answer,
    required this.userId,
    required this.id,
    this.answeredAt,
    this.isSynced = false,
  });

  factory SurveyAnswerPayload.fromDatabase(Map<String, dynamic> row) {
    return SurveyAnswerPayload(
      id: row['id'] as String,
      questionId: row['question_id'] as String,
      surveyVersionId: row['survey_version_id'] as String,
      userId: row['user_id'] as String,
      answer: row['answer'] as String,
      answeredAt: row['answered_at'] as DateTime?,
      isSynced: row['is_synced'] == 1 || row['is_synced'] == true,
    );
  }

  final String id;
  final String questionId;
  final String surveyVersionId;
  final String userId;
  final String answer;
  final DateTime? answeredAt;
  final bool isSynced;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'survey_version_id': surveyVersionId,
      'user_id': userId,
      'answer': answer,
      'answered_at': answeredAt?.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  Map<String, dynamic> toRemotePayload() {
    return {
      'question_id': questionId,
      'survey_version_id': surveyVersionId,
      'answer': jsonDecode(answer),
      'answered_at': answeredAt?.toIso8601String(),
    };
  }
}
