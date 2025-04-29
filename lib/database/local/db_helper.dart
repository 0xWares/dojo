import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  // Singleton instance
  static final DbHelper getInstance = DbHelper._();
  static final tableName = 'dojo';
  static final serialNumber = 'sl_no';
  static final noteTitle = 'title';
  static final noteDescription = 'description';
  static final noteStatus = 'status';
  Database? myDB;
  Future<Database> getDB() async {
    var dbget = myDB ??= await openDB();
    return dbget;
    // if (myDB != null) {
    //   return myDB!;
    // } else {
    //   myDB = await openDB();
    //   return myDB!;
    // }
  }

  Future<Database> openDB() async {
    Directory appPath = await getApplicationDocumentsDirectory();
    String dbPath = join(appPath.path, 'dojo.db');
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          "create table $tableName ($serialNumber integer primary key autoincrement, $noteTitle TEXT, $noteDescription TEXT, $noteStatus BOOLEAN)",
        );
      },
      version: 1,
    );
  }

  Future<bool> addNote({
    required String title,
    required String description,
    bool status = false,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.insert(tableName, {
      noteTitle: title,
      noteDescription: description,
      noteStatus: status,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> myData = await db.query(tableName);
    return myData;
  }

  Future<bool> updateTask({
    required String mTitle,
    required String mDescription,

    required int mSerialNumber,
  }) async {
    var db = await getDB();
    var rowsEffected = await db.update(tableName, {
      noteTitle: mTitle,
      noteDescription: mDescription,
    }, where: '$serialNumber = $mSerialNumber');
    return rowsEffected > 0;
  }

  Future<bool> deleteTask({required int serialNumber}) async {
    var db = await getDB();
    var rowsEffected = await db.delete(
      tableName,
      where: '${DbHelper.serialNumber} = ?',
      whereArgs: [serialNumber],
    );
    return rowsEffected > 0;
  }
}
