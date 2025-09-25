import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:tochka_rosta/core/database/app_database.dart';
import 'package:tochka_rosta/core/database/repositories/messages_repository.dart';
import 'package:tochka_rosta/core/database/repositories/responses_repository.dart';

void main() {
  group('MessagesRepository', () {
    late AppDatabase db;
    late MessagesRepository repository;

    setUp(() async {
      db = AppDatabase.connect(NativeDatabase.memory());
      repository = MessagesRepository(db.messagesDao);

      await db.usersDao.upsertUser(const UsersCompanion(
        id: Value('user-1'),
      ));
      await db.chatsDao.upsertChat(const ChatsCompanion(
        id: Value('chat-1'),
        userId: Value('user-1'),
      ));
    });

    tearDown(() async {
      await db.close();
    });

    test('upsertMessage inserts and updates', () async {
      final sentAt = DateTime(2024, 1, 1, 12, 0);
      final message = Message(
        id: 'message-1',
        chatId: 'chat-1',
        senderId: 'user-1',
        body: 'Hello',
        messageType: 'text',
        isRead: false,
        sentAt: sentAt,
        updatedAt: null,
      );

      await repository.upsertMessage(message);
      var stored = await db.messagesDao.messagesForChat('chat-1');
      expect(stored, hasLength(1));
      expect(stored.first.body, 'Hello');

      final updated = message.copyWith(body: 'Hello again');
      await repository.upsertMessage(updated);

      stored = await db.messagesDao.messagesForChat('chat-1');
      expect(stored, hasLength(1));
      expect(stored.first.body, 'Hello again');
    });

    test('batchUpsertMessages inserts many records', () async {
      final messages = List.generate(
        5,
        (index) => Message(
          id: 'message-${index + 1}',
          chatId: 'chat-1',
          senderId: 'user-1',
          body: 'Message ${index + 1}',
          messageType: 'text',
          isRead: false,
          sentAt: DateTime(2024, 1, 1, 12, index),
          updatedAt: null,
        ),
      );

      await repository.batchUpsertMessages(messages);

      final stored = await db.messagesDao.messagesForChat('chat-1');
      expect(stored, hasLength(5));
    });

    test('paginateMessages returns messages ordered by sentAt desc', () async {
      final messages = List.generate(
        5,
        (index) => Message(
          id: 'message-${index + 1}',
          chatId: 'chat-1',
          senderId: 'user-1',
          body: 'Message ${index + 1}',
          messageType: 'text',
          isRead: false,
          sentAt: DateTime(2024, 1, 1, 12, index),
          updatedAt: null,
        ),
      );

      await repository.batchUpsertMessages(messages);

      final firstPage = await repository.paginateMessages(
        'chat-1',
        limit: 2,
      );
      expect(firstPage.map((m) => m.id), ['message-5', 'message-4']);

      final secondPage = await repository.paginateMessages(
        'chat-1',
        limit: 2,
        before: firstPage.last.sentAt,
      );
      expect(secondPage.map((m) => m.id), ['message-3', 'message-2']);
    });
  });

  group('ResponsesRepository', () {
    late AppDatabase db;
    late ResponsesRepository repository;

    setUp(() async {
      db = AppDatabase.connect(NativeDatabase.memory());
      repository = ResponsesRepository(db.responsesDao);

      await db.usersDao.upsertUser(const UsersCompanion(
        id: Value('user-1'),
      ));
      await db.surveyVersionsDao.upsertSurveyVersion(const SurveyVersionsCompanion(
        id: Value('survey-1'),
        versionNumber: Value(1),
        title: Value('Survey 1'),
      ));
      await db.surveySectionsDao.upsertSection(const SurveySectionsCompanion(
        id: Value('section-1'),
        surveyVersionId: Value('survey-1'),
        title: Value('Section 1'),
        position: Value(0),
      ));

      for (var i = 0; i < 3; i++) {
        await db.questionsDao.upsertQuestion(QuestionsCompanion.insert(
          id: 'question-${i + 1}',
          surveySectionId: 'section-1',
          surveyVersionId: 'survey-1',
          questionType: 'text',
          text: 'Question ${i + 1}',
          position: i,
        ));
      }
    });

    tearDown(() async {
      await db.close();
    });

    test('upsertResponse and pagination', () async {
      final responses = List.generate(
        3,
        (index) => Response(
          id: 'response-${index + 1}',
          questionId: 'question-${index + 1}',
          userId: 'user-1',
          surveyVersionId: 'survey-1',
          answer: 'Answer ${index + 1}',
          answeredAt: DateTime(2024, 1, 1, 13, index),
          isSynced: false,
          updatedAt: null,
        ),
      );

      await repository.batchUpsertResponses(responses);

      final firstPage = await repository.paginateResponses(
        'survey-1',
        'user-1',
        limit: 2,
      );
      expect(firstPage.map((r) => r.id), ['response-3', 'response-2']);

      final secondPage = await repository.paginateResponses(
        'survey-1',
        'user-1',
        limit: 2,
        before: firstPage.last.answeredAt,
      );
      expect(secondPage.map((r) => r.id), ['response-1']);
    });

    test('getSurveyProgress returns completed count and total', () async {
      await repository.upsertResponse(Response(
        id: 'response-1',
        questionId: 'question-1',
        userId: 'user-1',
        surveyVersionId: 'survey-1',
        answer: 'Answer 1',
        answeredAt: DateTime(2024, 1, 1, 13),
        isSynced: false,
        updatedAt: null,
      ));

      await repository.upsertResponse(Response(
        id: 'response-2',
        questionId: 'question-2',
        userId: 'user-1',
        surveyVersionId: 'survey-1',
        answer: 'Answer 2',
        answeredAt: DateTime(2024, 1, 1, 13, 30),
        isSynced: false,
        updatedAt: null,
      ));

      final progress = await repository.getSurveyProgress('survey-1', 'user-1');
      expect(progress.totalQuestions, 3);
      expect(progress.answeredQuestions, 2);
      expect(progress.progress, closeTo(2 / 3, 0.001));
    });
  });
}
