import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';



class NoteService{
  Database? _db;
  List <DataBaseNote> _notes =[];
  final _notesStreamController =
  StreamController<List<DataBaseNote>>.broadcast();


  Future<void> _cacheNotes() async{
    final allNotes= await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<void>open() async{
    if(_db != null)
      {
        throw DatabaseAlreadyOpenException();
      }
      try{
      final docsPath= await getApplicationCacheDirectory();
      final dbPath = join(docsPath.path,dbName);
      final db = await openDatabase(dbPath);
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      await _cacheNotes();
      }on MissingPlatformDirectoryException {
        throw UnableToGetToDocumentsDirectory();
      }
  }


  Future<void>close()async{
    final db =_db;
    if(db == null) {
      throw DatabaseIsNotOpen();
      } else {
      await db.close();
      _db= null ;
    }
  }


  Database _getDatabaseOrThrow(){
    final db = _db ;
    if(db == null){
      throw DatabaseIsNotOpen();
    }else{
      return db;
    }
  }


  Future<void>deleteUser({required email}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount= await db.delete(
      userTable,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    ) ;
  }


  Future<DataBaseUser> createUser ({required String email})async{
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email =? ',
      whereArgs: [email.toLowerCase()],
    ) ;
    if(results.isNotEmpty){
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable,
        {emailColoumn: email.toLowerCase(),
    }) ;
    return DataBaseUser(
      id: userId,
      email: email,
    );
  }


  Future<DataBaseUser> getUser({required String email})async{
    final db= _getDatabaseOrThrow();
    final results = await db.query(userTable,
      limit: 1,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if(results.isEmpty){
      throw CouldNotFindUser();
    }else{
      return DataBaseUser.fromRow(results.first);
    }
  }


  Future<DataBaseNote> createNote({required DataBaseUser owner}) async{
    //make sure owner exists in the database with the correct id
    final db= await _getDatabaseOrThrow();
    final dbUser= getUser(email: owner.email);
    if(dbUser != owner){
      throw CouldNotFindUser();
    }
    const text='';
    //create note
    final noteId= await db.insert(noteTable, {userIdColoumn: owner.id,
    textColoumn: text,
    isSyncedWithCloudColoumn:1
    });
    final note =DataBaseNote(id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }


  Future<void> deleteNote({required int id}) async{
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
        noteTable,
        where: 'id = ?',
        whereArgs: [id]
    );
    if(deleteCount ==0)
      {
        throw CouldNotDeleteNote();
      } else{
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }


  Future<int> deleteAllNotes() async {
    final db =_getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }


  Future<DataBaseNote> getNote({required int id}) async{
    final db =_getDatabaseOrThrow();
    final notes = await db.query(
        noteTable,
        whereArgs: [id],
        where: 'id = ?',
        limit: 1
    );
    if(notes.isEmpty){
      throw CouldNotFindNote();
    } else{
      final note = DataBaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }


  Future<Iterable<DataBaseNote>> getAllNotes() async{
    final db = _getDatabaseOrThrow();
    final notes = await db. query(noteTable);
    return notes.map((noteRow) => DataBaseNote.fromRow(noteRow));
  }


  Future<DataBaseNote> updateNote({required DataBaseNote note, required String text}) async{
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(
        noteTable,
        {
          textColoumn:text,
          isSyncedWithCloudColoumn: 0
        });
    if(updatesCount == 0){
      throw CouldNotUpdateNote();
    }else{
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }

  }


  Future<DataBaseUser> getOrCreateUser  ({ required String email})async{
    try{
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser{
      final create_user = await createUser(email: email);
      return create_user;
    } catch(e){
      rethrow;
    }
  }
}






@immutable
class DataBaseUser{
  final int id;
  final String email;

  const DataBaseUser({
    required this.id,
    required this.email
  });

  DataBaseUser.fromRow(Map<String, Object?>map)
  : id= map[idColoumn] as int,
  email = map[emailColoumn] as String;

  @override
  String toString()=>'Person, ID=$id, email=$email';

  @override
  bool operator ==(covariant DataBaseUser other)=>id==this.id ;

  @override
  int get hashCode => id.hashCode;


}

class DataBaseNote{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DataBaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud
  });
  DataBaseNote.fromRow(Map<String,Object?> map)
  :id= map[idColoumn] as int ,
  userId= map[userIdColoumn] as int ,
        text= map[textColoumn] as String,
  isSyncedWithCloud= (map [isSyncedWithCloudColoumn] as int == 1 ?true:false) ;
@override
  String toString() => 'Note, ID =$id , User ID= $userId, is Synced with Cloud = $isSyncedWithCloud, Text= $text';

@override
  bool operator ==(covariant DataBaseNote other)=>id==this.id ;


@override
  int get hashCode => id.hashCode;

}
const dbName ='notes.db';
const noteTable='note';
const userTable='User';
const textColoumn = 'text' ;
const isSyncedWithCloudColoumn='is_synced_with_cloud' ;
const userIdColoumn='user_id';
const idColoumn ='ID';
const emailColoumn ='Email';
const createUserTable='''CREATE TABLE  IF NOT EXISTS "User" (
	"ID"	INTEGER NOT NULL,
	"Email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
''';
const createNoteTable ='''CREATE TABLE IF NOT EXISTS "note" (
	"ID"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	INTEGER,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("user_id") REFERENCES "User"("ID"),
	PRIMARY KEY("ID")
);
''';
