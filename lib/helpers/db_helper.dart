import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'locations.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_locations(date TEXT PRIMARY KEY, title TEXT, description TEXT, camera TEXT, lens TEXT, aperture TEXT, exposureTime TEXT, iso TEXT, lat DOUBLE, long DOUBLE, filelink TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> update(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.update(
      table,
      data,
      where: 'date = ?',
      whereArgs: [data['date'].toString()],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.delete(
      table,
      where: 'date = ?',
      whereArgs: [data['date'].toString()],
    );
  }
}
