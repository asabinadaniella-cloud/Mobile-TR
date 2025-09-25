import 'package:tochka_rosta/core/database/app_database.dart';

class ResponsesRepository {
  ResponsesRepository(this._responsesDao);

  final ResponsesDao _responsesDao;

  Future<void> upsertResponse(Response response) =>
      _responsesDao.upsertResponse(response);

  Future<void> batchUpsertResponses(List<Response> responses) =>
      _responsesDao.insertResponsesBatch(responses);

  Future<List<Response>> paginateResponses(
    String surveyVersionId,
    String userId, {
    required int limit,
    DateTime? before,
  }) =>
      _responsesDao.fetchResponsesPage(
        surveyVersionId,
        userId,
        limit: limit,
        before: before,
      );

  Future<SurveyProgress> getSurveyProgress(
    String surveyVersionId,
    String userId,
  ) =>
      _responsesDao.getSurveyProgress(surveyVersionId, userId);
}
