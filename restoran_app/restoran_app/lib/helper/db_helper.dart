import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:restoran_app/model/fav_model.dart';

class DbHelper {
  static late Database _database;

  static DbHelper? _dbHelper;

  DbHelper._internal() {
    _dbHelper = this;
  }

  factory DbHelper() => _dbHelper ?? DbHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static String _tableName = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'fav_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
               inc INTEGER PRIMARY KEY AUTOINCREMENT,
               id TEXT,
               name TEXT, 
               city TEXT,
               pictureId TEXT
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertFav(Fav fav) async {
    final Database db = await database;
    await db.insert(_tableName, fav.toMap());
    print('Data saved');
  }

  Future<List<Fav>> getFavList() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Fav.fromMap(res)).toList();
  }

  Future<Fav> getFavById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((res) => Fav.fromMap(res)).first;
  }

  Future<void> updateFav(Fav fav) async {
    final db = await database;

    await db.update(
      _tableName,
      fav.toMap(),
      where: 'id = ?',
      whereArgs: [fav.id],
    );
  }

  Future<void> deleteFav(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
