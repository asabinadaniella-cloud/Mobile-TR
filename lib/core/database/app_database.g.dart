// GENERATED CODE - PLACEHOLDER FOR DRIFT BUILDERS
// ignore_for_file: type=lint
part of 'app_database.dart';

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  late final $SurveyEntriesTable surveyEntries = $SurveyEntriesTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [surveyEntries];
}

class $SurveyEntriesTable extends SurveyEntries with TableInfo<$SurveyEntriesTable, SurveyEntry> {
  $SurveyEntriesTable(this.attachedDatabase);

  final GeneratedDatabase attachedDatabase;

  @override
  SurveyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurveyEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }
}

class SurveyEntry {
  const SurveyEntry({required this.id, required this.title, this.description, required this.createdAt});

  final int id;
  final String title;
  final String? description;
  final DateTime createdAt;
}
