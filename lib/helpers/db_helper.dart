import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database(String table) async {
    final dbPath = await getDatabasesPath();
    return openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $table(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await DBHelper.database(table);

    sqlDb.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object>>> fetchData(String table) async {
    final sqlDb = await DBHelper.database(table);
    return sqlDb.query(table);
  }
}
