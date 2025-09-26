import 'package:equatable/equatable.dart';

enum ReportStatus {
  inReview('in_review'),
  ready('ready');

  const ReportStatus(this.apiValue);

  final String apiValue;

  static ReportStatus fromApi(String value) {
    return ReportStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => ReportStatus.inReview,
    );
  }
}

class ReportRecommendation extends Equatable {
  const ReportRecommendation({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  @override
  List<Object?> get props => [id, title, description];
}

class Report extends Equatable {
  const Report({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.summary,
    required this.recommendations,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String subtitle;
  final ReportStatus status;
  final Map<String, dynamic> summary;
  final List<ReportRecommendation> recommendations;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Report copyWith({
    ReportStatus? status,
    Map<String, dynamic>? summary,
    List<ReportRecommendation>? recommendations,
    DateTime? updatedAt,
  }) {
    return Report(
      id: id,
      title: title,
      subtitle: subtitle,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, status, summary, recommendations, createdAt, updatedAt];
}
