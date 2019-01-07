import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io' as io;
import 'Contact.dart';

class DataBaseHelper {

  static Database dbInstance;
  static const String db_name = 'MyDatabase';
  static const String tableName = 'MyTable';
  static const String col0 = "ID";
  static const String col1 = "Name";
  static const String col2 = "Phone";

  Future<Database> get db async {
    if (dbInstance == null)
      dbInstance = await initDb();

    return dbInstance;
  }

  initDb() async {

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, db_name);
    var db = await openDatabase(path, version: 1, onCreate: onCreateFun);

    return db;
  }

  onCreateFun(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName ($col0 INTEGER PRIMARY KEY AUTOINCREMENT, $col1 TEXT, $col2 TEXT)');
  }

  Future<List<Contact>> getContacts() async {

    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM $tableName');
    List contacts = new List<Contact>();

    for (int i = 0; i < list.length; i++) {

      Contact contact = new Contact();
      contact.id = list[i][col0];
      contact.name = list[i][col1];
      contact.id = list[i][col2];

      contacts.add(contact);
    }

    return contacts;
  }

  addNewContact(Contact contact) async {

    var db_connection = await db;
    String query = 'INSERT INTO $tableName($col1, $col2) VALUES(\'${contact.name}\',\'${contact.phone}\')';
    await db_connection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
   }

   updateContact(Contact contact) async {

    var db_connection = await db;
    String query = 'UPDATE $tableName SET $col1=\'${contact.name}\',$col2=\'${contact.phone}\'WHERE $col0=${contact.id}';
    await db_connection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
   }

   deleteContact(Contact contact) async {

    var db_conntection = await db;
    String query = 'DELETE FROM $tableName WHERE $col0=${contact.id}';
    await db_conntection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });

   }

}
