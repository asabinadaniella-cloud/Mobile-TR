import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnectionImpl() {
  return WebDatabase('tochka_rosta');
}
