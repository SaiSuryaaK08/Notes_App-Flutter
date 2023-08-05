

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:znotes/model/note_model.dart';
class DatabaseProvider{
  DatabaseProvider._();//private constructor
  static final DatabaseProvider db=DatabaseProvider._();
  static Database? _database;

  //getter db
  Future<Database> get database async{
    if(_database!=null){
      return _database!;//! removes null error
    }
    _database??=await initDB();
    return _database!;
  }

  Future<Database> initDB()async{
    return await openDatabase(join(await getDatabasesPath(),"notes_app.db"),
      onCreate: (db,version)async{
      //create database table
        await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          body TEXT,
          creation_date DATE 
        )
        ''');
      },version :1);
  }

  //function to add new note to our variable

  addNewNotes(NoteModel note)async{
    final db = await database;
    db.insert('notes', note.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //func to return all elements in a database inside notes table
  Future<dynamic> getNotes()async{
    final db =await database;
    var res =await db.query('notes');
    if(res.length==0) {
      return Null;
    }else{
      var resultMap= res.toList();
      return resultMap.isNotEmpty ? resultMap: Null;
    }
  }
  Future<int> deleteNote(int id)async{
    final db= await database;
    int count= await db.rawDelete('DELETE FROM notes WHERE id=?',[id]);
    return count;
  }

}