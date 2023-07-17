import 'package:drift/drift.dart';

class Reasons extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
}
