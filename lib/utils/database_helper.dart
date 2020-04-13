import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class databaseHelper {
  static databaseHelper _databaseHelper; //Singleton Dtabase helper
  static Database _database;
  String noteTable='note_table';
  String colId='id';
  String colTitle='title';
  String colDesc='description';
  String colPriority='priority';
  String coldate='date';
  databaseHelper._createInstance(); //Need constructor to Create instance of DatabaseHelper
  factory databaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = databaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async{
    if(_database==null){
      _database=await initialiseDatabase();
    }
    return _database;
  }
  Future<Database> initialiseDatabase() async{
    Directory directory = await getApplicationSupportDirectory();
    String path= directory.path+ 'notes.db';
    var notesdatabse=openDatabase(path, version: 1,onCreate: _createDb);
    return notesdatabse;
  }
  void _createDb(Database db,int newVersion) async{
    String sqlCreateDb="CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDesc TEXT,$colPriority INTEGER,$coldate TEXT)";
    await db.execute(sqlCreateDb);
  }
  //*** CRUD Operation
  //Fetch Operation
  Future<List<Map<String,dynamic>>>getNoteMapList() async{
    Database db=await this.database;
    //var result= await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result=await db.query(noteTable,orderBy: '$colPriority ASC');
    return result;
  }
  //Insert Operation : Insert a Note Object to database
Future<int> insertNote(note _note) async{
    Database db= await this.database;
    var result= await db.insert(noteTable, _note.toMap());
    return result;
}
  //Update Operation :
  Future<int> updateNote(note _note) async{
    Database db= await this.database;
    var result= await db.update(noteTable, _note.toMap(),where: '$colId = ?',whereArgs: [_note.id]);
    return result;
  }
  //Delete Operation
  Future<int> deleteNote(int id) async{
    Database db= await this.database;
    var result= await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }
  //Count Operation : Get total record inserted
  Future<int> getCount() async{
    Database db= await this.database;
    List <Map<String,dynamic>> x= await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int result= Sqflite.firstIntValue(x);
    return result;
  }
  //get the 'Map List [List<Map>] and Convert it to Note List [List<Note>]
  Future<List<note>> getNoteList() async{
    var noteMapList=await getNoteMapList();
    int count= noteMapList.length;
    List<note> noteList=List<note>();
    for(int i=0;i<count;i++){
      noteList.add(note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
