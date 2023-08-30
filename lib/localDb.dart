import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;

class LocalDatabase {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Local.db');
    return _database;
  }

  Future _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      '''
CREATE TABLE Localdata(
id INTEGER PRIMARY KEY,
Name TEXT NOT NULL
)
      '''
    );
  }

  Future addDataLocally({Name}) async {
    final db = await database;
    await db.insert('Localdata', {'Name': Name});
    print('${Name} Added to database successfally');
    return 'added';
  }

}






















