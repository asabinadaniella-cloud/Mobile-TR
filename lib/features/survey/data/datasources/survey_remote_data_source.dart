import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../models/survey_models.dart';

class SurveyRemoteDataSource {
  SurveyRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SurveyVersionModel> fetchActiveSurvey() async {
    final response = await _dio.get<dynamic>('/surveys/active');
    final data = response.data as Map<String, dynamic>;
    return SurveyVersionModel.fromJson(data);
  }

  Future<void> submitResponse(SurveyAnswerPayload payload) async {
    await _dio.post<dynamic>(
      '/surveys/${payload.surveyVersionId}/questions/${payload.questionId}/responses',
      data: payload.toRemotePayload(),
    );
  }
}

final surveyRemoteDataSourceProvider = Provider<SurveyRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return SurveyRemoteDataSource(dio);
});
