
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:solocoding2019_base/models/Tasks.dart';

class DbHelper {
  String tblList = "Lists";
  String colId = "Id";
  String colTitle = "Title";
  String colDate = "Date";
  String colCompleted = "Completed";

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

  factory DbHelper(){
    return _dbHelper;
  }

  static Database _db;
  Future<Database> get db async{
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "tasks.db";
    var dbList = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbList;
  }

  void _createDb(Database db, int version) async{
    await db.execute("Create Table $tblList($colId integer primary key, $colTitle text, $colDate text, $colCompleted text)");
  }

  Future<int> insert(Tasks tasks) async{
    Database db = await this.db;
    var result = await db.insert(tblList, tasks.toMap());
    return result;
  }

  Future<List> getTasks() async{
    Database db = await this.db;
    var result = await db.rawQuery("Select * From $tblList");
    return result;
  }

}