import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;
List WholeDataList = [];

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

  Future readAllData() async {
    final db = await database;
    final allData = await db!.query('Localdata');
    WholeDataList = allData;
    return WholeDataList;
  }

  Future updateData({Name, id}) async{
    final db = await database;
    int dbUpdateId = await db.rawUpdate(
      'UPDATE Localdata SET Name=? WHERE id=?', [Name, id]
    );
    print('UPDATE Localdata SET Name=? WHERE id=${id}');
    return dbUpdateId;
  }

  Future deleteId({id}) async {
    final db = await database;
    await db!.delete('Localdata', where: 'id=?', whereArgs: [id]);
    print('deleted successfully id=${id}');
    return 'deleted successfully';
  }

  Future deleteAll() async {
    final db = await database;
    await db.delete('Localdata');
    print('deleted successfully');
    return 'deleted successfully';
  }

}






















