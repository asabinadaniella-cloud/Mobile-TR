import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get middleName => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get city => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => [
        {userId},
      ];
}

class SurveyVersions extends Table {
  TextColumn get id => text()();
  IntColumn get versionNumber => integer()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get publishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => [
        {versionNumber},
      ];
}

class SurveySections extends Table {
  TextColumn get id => text()();
  TextColumn get surveyVersionId => text().references(SurveyVersions, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get position => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('survey_sections_version_position_idx', [surveyVersionId, position]),
      ];
}

class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get surveySectionId => text().references(SurveySections, #id)();
  TextColumn get surveyVersionId => text().references(SurveyVersions, #id)();
  TextColumn get questionType => text()();
  TextColumn get text => text()();
  TextColumn get helpText => text().nullable()();
  BoolColumn get isRequired => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
  TextColumn get validationRules => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('questions_section_position_idx', [surveySectionId, position]),
        Index('questions_version_idx', [surveyVersionId]),
      ];
}

class QuestionOptions extends Table {
  TextColumn get id => text()();
  TextColumn get questionId => text().references(Questions, #id)();
  TextColumn get value => text()();
  TextColumn get label => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('question_options_question_idx', [questionId, position]),
      ];
}

class Responses extends Table {
  TextColumn get id => text()();
  TextColumn get questionId => text().references(Questions, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get surveyVersionId => text().references(SurveyVersions, #id)();
  TextColumn get answer => text()();
  DateTimeColumn get answeredAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('responses_question_user_idx', [questionId, userId], unique: true),
        Index('responses_survey_user_idx', [surveyVersionId, userId]),
        Index('responses_answered_at_idx', [answeredAt]),
      ];
}

class Reports extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get surveyVersionId => text().references(SurveyVersions, #id)();
  TextColumn get status => text()();
  TextColumn get url => text().nullable()();
  DateTimeColumn get generatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('reports_user_idx', [userId]),
        Index('reports_survey_idx', [surveyVersionId]),
      ];
}

class Chats extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get title => text().nullable()();
  TextColumn get status => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('chats_user_idx', [userId]),
      ];
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text().references(Chats, #id)();
  TextColumn get senderId => text().references(Users, #id)();
  TextColumn get body => text()();
  TextColumn get messageType => text().withDefault(const Constant('text'))();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get sentAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('messages_chat_sent_idx', [chatId, sentAt]),
      ];
}

@DataClassName('FileEntity')
class Files extends Table {
  TextColumn get id => text()();
  TextColumn get messageId => text().nullable().references(Messages, #id)();
  TextColumn get ownerId => text().nullable().references(Users, #id)();
  TextColumn get url => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get size => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('files_message_idx', [messageId]),
        Index('files_owner_idx', [ownerId]),
      ];
}

class PushTokens extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get token => text()();
  TextColumn get deviceType => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('push_tokens_token_idx', [token], unique: true),
        Index('push_tokens_user_idx', [userId]),
      ];
}

class AuditLog extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  TextColumn get actorId => text().nullable().references(Users, #id)();
  TextColumn get payload => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Index> get indexes => [
        Index('audit_log_entity_idx', [entityType, entityId]),
        Index('audit_log_actor_idx', [actorId]),
      ];
}

@DriftDatabase(
  tables: [
    Users,
    Profiles,
    SurveyVersions,
    SurveySections,
    Questions,
    QuestionOptions,
    Responses,
    Reports,
    Chats,
    Messages,
    Files,
    PushTokens,
    AuditLog,
  ],
  daos: [
    UsersDao,
    ProfilesDao,
    SurveyVersionsDao,
    SurveySectionsDao,
    QuestionsDao,
    QuestionOptionsDao,
    ResponsesDao,
    ReportsDao,
    ChatsDao,
    MessagesDao,
    FilesDao,
    PushTokensDao,
    AuditLogDao,
  ],
)
static const List<String> _createIndexStatements = [
  'CREATE INDEX IF NOT EXISTS idx_survey_sections_version_position ON survey_sections(survey_version_id, position)',
  'CREATE INDEX IF NOT EXISTS idx_questions_section_position ON questions(survey_section_id, position)',
  'CREATE INDEX IF NOT EXISTS idx_questions_version ON questions(survey_version_id)',
  'CREATE INDEX IF NOT EXISTS idx_question_options_question ON question_options(question_id, position)',
  'CREATE UNIQUE INDEX IF NOT EXISTS idx_responses_question_user ON responses(question_id, user_id)',
  'CREATE INDEX IF NOT EXISTS idx_responses_survey_user ON responses(survey_version_id, user_id)',
  'CREATE INDEX IF NOT EXISTS idx_responses_answered_at ON responses(answered_at)',
  'CREATE INDEX IF NOT EXISTS idx_reports_user ON reports(user_id)',
  'CREATE INDEX IF NOT EXISTS idx_reports_survey ON reports(survey_version_id)',
  'CREATE INDEX IF NOT EXISTS idx_chats_user ON chats(user_id)',
  'CREATE INDEX IF NOT EXISTS idx_messages_chat_sent ON messages(chat_id, sent_at)',
  'CREATE INDEX IF NOT EXISTS idx_files_message ON files(message_id)',
  'CREATE INDEX IF NOT EXISTS idx_files_owner ON files(owner_id)',
  'CREATE UNIQUE INDEX IF NOT EXISTS idx_push_tokens_token ON push_tokens(token)',
  'CREATE INDEX IF NOT EXISTS idx_push_tokens_user ON push_tokens(user_id)',
  'CREATE INDEX IF NOT EXISTS idx_audit_log_entity ON audit_log(entity_type, entity_id)',
  'CREATE INDEX IF NOT EXISTS idx_audit_log_actor ON audit_log(actor_id)',
];
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  AppDatabase.connect(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < to) {
            await m.createAll();
          }
          await _createIndexes();
        },
      );

  Future<void> _createIndexes() async {
    for (final statement in _createIndexStatements) {
      await customStatement(statement);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tochka_rosta.db'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(AppDatabase db) : super(db);

  Future<void> upsertUser(Insertable<User> entry) => into(users).insertOnConflictUpdate(entry);

  Future<User?> findById(String id) => (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<User>> getUsers() => select(users).get();
}

@DriftAccessor(tables: [Profiles])
class ProfilesDao extends DatabaseAccessor<AppDatabase> with _$ProfilesDaoMixin {
  ProfilesDao(AppDatabase db) : super(db);

  Future<void> upsertProfile(Insertable<Profile> entry) => into(profiles).insertOnConflictUpdate(entry);

  Future<Profile?> findByUser(String userId) =>
      (select(profiles)..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();
}

@DriftAccessor(tables: [SurveyVersions])
class SurveyVersionsDao extends DatabaseAccessor<AppDatabase> with _$SurveyVersionsDaoMixin {
  SurveyVersionsDao(AppDatabase db) : super(db);

  Future<void> upsertSurveyVersion(Insertable<SurveyVersion> entry) =>
      into(surveyVersions).insertOnConflictUpdate(entry);

  Future<SurveyVersion?> getActiveVersion() =>
      (select(surveyVersions)..where((tbl) => tbl.isActive.equals(true))).getSingleOrNull();
}

@DriftAccessor(tables: [SurveySections])
class SurveySectionsDao extends DatabaseAccessor<AppDatabase> with _$SurveySectionsDaoMixin {
  SurveySectionsDao(AppDatabase db) : super(db);

  Future<void> upsertSection(Insertable<SurveySection> entry) =>
      into(surveySections).insertOnConflictUpdate(entry);

  Future<List<SurveySection>> sectionsByVersion(String surveyVersionId) =>
      (select(surveySections)..where((tbl) => tbl.surveyVersionId.equals(surveyVersionId))).get();
}

@DriftAccessor(tables: [Questions])
class QuestionsDao extends DatabaseAccessor<AppDatabase> with _$QuestionsDaoMixin {
  QuestionsDao(AppDatabase db) : super(db);

  Future<void> upsertQuestion(Insertable<Question> entry) =>
      into(questions).insertOnConflictUpdate(entry);

  Future<List<Question>> questionsForVersion(String surveyVersionId) =>
      (select(questions)..where((tbl) => tbl.surveyVersionId.equals(surveyVersionId))).get();
}

@DriftAccessor(tables: [QuestionOptions])
class QuestionOptionsDao extends DatabaseAccessor<AppDatabase> with _$QuestionOptionsDaoMixin {
  QuestionOptionsDao(AppDatabase db) : super(db);

  Future<void> upsertOption(Insertable<QuestionOption> entry) =>
      into(questionOptions).insertOnConflictUpdate(entry);

  Future<List<QuestionOption>> optionsForQuestion(String questionId) =>
      (select(questionOptions)..where((tbl) => tbl.questionId.equals(questionId))).get();
}

@DriftAccessor(tables: [Responses, Questions, SurveySections])
class ResponsesDao extends DatabaseAccessor<AppDatabase> with _$ResponsesDaoMixin {
  ResponsesDao(AppDatabase db) : super(db);

  Future<void> upsertResponse(Insertable<Response> entry) =>
      into(responses).insertOnConflictUpdate(entry);

  Future<void> insertResponsesBatch(List<Insertable<Response>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(responses, entries);
    });
  }

  Future<List<Response>> fetchResponsesPage(
    String surveyVersionId,
    String userId, {
    required int limit,
    DateTime? before,
  }) {
    final query = select(responses)
      ..where((tbl) => tbl.surveyVersionId.equals(surveyVersionId) & tbl.userId.equals(userId));

    if (before != null) {
      query.where((tbl) => tbl.answeredAt.isSmallerThanValue(before));
    }

    query
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.answeredAt, mode: OrderingMode.desc)])
      ..limit(limit);

    return query.get();
  }

  Future<SurveyProgress> getSurveyProgress(String surveyVersionId, String userId) async {
    final totalExpr = questions.id.count();
    final totalQuery = selectOnly(questions)
      ..join([
        innerJoin(
          surveySections,
          surveySections.id.equalsExp(questions.surveySectionId),
        ),
      ])
      ..where(surveySections.surveyVersionId.equals(surveyVersionId));
    totalQuery.addColumns([totalExpr]);
    final totalRow = await totalQuery.getSingleOrNull();
    final totalQuestions = totalRow?.read(totalExpr) ?? 0;

    final answeredExpr = responses.questionId.count(distinct: true);
    final answeredQuery = selectOnly(responses)
      ..where(
        responses.surveyVersionId.equals(surveyVersionId) &
            responses.userId.equals(userId),
      );
    answeredQuery.addColumns([answeredExpr]);
    final answeredRow = await answeredQuery.getSingleOrNull();
    final answeredQuestions = answeredRow?.read(answeredExpr) ?? 0;

    return SurveyProgress(
      totalQuestions: totalQuestions,
      answeredQuestions: answeredQuestions,
    );
  }
}

@DriftAccessor(tables: [Reports])
class ReportsDao extends DatabaseAccessor<AppDatabase> with _$ReportsDaoMixin {
  ReportsDao(AppDatabase db) : super(db);

  Future<void> upsertReport(Insertable<Report> entry) =>
      into(reports).insertOnConflictUpdate(entry);

  Future<List<Report>> reportsForUser(String userId) =>
      (select(reports)..where((tbl) => tbl.userId.equals(userId))).get();
}

@DriftAccessor(tables: [Chats])
class ChatsDao extends DatabaseAccessor<AppDatabase> with _$ChatsDaoMixin {
  ChatsDao(AppDatabase db) : super(db);

  Future<void> upsertChat(Insertable<Chat> entry) => into(chats).insertOnConflictUpdate(entry);

  Future<List<Chat>> chatsForUser(String userId) =>
      (select(chats)..where((tbl) => tbl.userId.equals(userId))).get();
}

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<AppDatabase> with _$MessagesDaoMixin {
  MessagesDao(AppDatabase db) : super(db);

  Future<void> upsertMessage(Insertable<Message> entry) =>
      into(messages).insertOnConflictUpdate(entry);

  Future<void> insertMessagesBatch(List<Insertable<Message>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(messages, entries);
    });
  }

  Future<List<Message>> fetchMessagesPage(
    String chatId, {
    required int limit,
    DateTime? before,
  }) {
    final query = select(messages)..where((tbl) => tbl.chatId.equals(chatId));

    if (before != null) {
      query.where((tbl) => tbl.sentAt.isSmallerThanValue(before));
    }

    query
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.sentAt, mode: OrderingMode.desc)])
      ..limit(limit);

    return query.get();
  }

  Future<List<Message>> messagesForChat(String chatId) =>
      (select(messages)..where((tbl) => tbl.chatId.equals(chatId))).get();
}

@DriftAccessor(tables: [Files])
class FilesDao extends DatabaseAccessor<AppDatabase> with _$FilesDaoMixin {
  FilesDao(AppDatabase db) : super(db);

  Future<void> upsertFile(Insertable<FileEntity> entry) =>
      into(files).insertOnConflictUpdate(entry);

  Future<List<FileEntity>> filesForMessage(String messageId) =>
      (select(files)..where((tbl) => tbl.messageId.equals(messageId))).get();
}

@DriftAccessor(tables: [PushTokens])
class PushTokensDao extends DatabaseAccessor<AppDatabase> with _$PushTokensDaoMixin {
  PushTokensDao(AppDatabase db) : super(db);

  Future<void> upsertToken(Insertable<PushToken> entry) =>
      into(pushTokens).insertOnConflictUpdate(entry);

  Future<PushToken?> findByToken(String tokenValue) =>
      (select(pushTokens)..where((tbl) => tbl.token.equals(tokenValue))).getSingleOrNull();
}

@DriftAccessor(tables: [AuditLog])
class AuditLogDao extends DatabaseAccessor<AppDatabase> with _$AuditLogDaoMixin {
  AuditLogDao(AppDatabase db) : super(db);

  Future<void> insertLog(Insertable<AuditLogData> entry) => into(auditLog).insert(entry);

  Future<List<AuditLogData>> logsForEntity(String entityType, String entityId) =>
      (select(auditLog)
            ..where(
              (tbl) => tbl.entityType.equals(entityType) & tbl.entityId.equals(entityId),
            )
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]))
          .get();
}

class SurveyProgress {
  const SurveyProgress({required this.totalQuestions, required this.answeredQuestions});

  final int totalQuestions;
  final int answeredQuestions;

  double get progress =>
      totalQuestions == 0 ? 0 : answeredQuestions / totalQuestions;
}
