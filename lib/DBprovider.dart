import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:order_app/model/cart.dart';
import 'dart:async';

class DBprovider {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'my_table';

  static final columnId = 'id';
  static final columnCode = 'code';

  static final columnImage = 'imageurl';
  static final columnDesc = 'desc';
  static final columnPrice = 'price';
  static final columnQuantity = 'quantity';
  static final columnTotal = 'total';

  // make this a singleton class
  DBprovider._privateConstructor();
  static final DBprovider instance = DBprovider._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,

            $columnCode TEXT NOT NULL,
            $columnImage TEXT NOT NULL,  
            $columnDesc TEXT NOT NULL,
            $columnPrice INTEGER,
            $columnQuantity INTEGER,
            $columnTotal INTEGER
          )
          ''');
  }

  // Helper methods

  //product_details

  Future<int> insert(Cart cart) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'code': cart.code,
      'imageurl': cart.imageurl,
      'desc': cart.desc,
      'price': cart.price,
      'quantity': cart.quantity,
      'total': cart.total
    });
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> calculateTotal() async {
    var db = await instance.database;
    int result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT SUM($columnTotal) as Total FROM $table"));
    print(result);
    return result;
  }

  Future<int> update(Map<String, dynamic> row, desc) async {
    Database db = await instance.database;
    String desc = row[columnDesc];
    print(desc);
    int qty = row[columnQuantity];
    print(qty);
    int tot = row[columnTotal];
    print(tot);
    return await db.rawUpdate(
        "UPDATE $table SET $columnQuantity=$qty,$columnTotal=$tot WHERE desc='$desc'");
    //return await db.rawUpdate(sql)
  }

  //del all table dtls
  Future<int> deletetable() async {
    Database db = await instance.database;
    // await db.delete(table2);
    return await db.delete(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT(*) FROM $table');
    int count = Sqflite.firstIntValue(x);
    print(count);
    return count;
  }

  Future<int> deleterow(String desc) async {
    Database db = await instance.database;
    print("desc");
    print(desc);
    return await db.delete(table, where: '$columnDesc = ?', whereArgs: [desc]);
  }

//view cart page

  Future<List<Map<String, dynamic>>> queryDetails() async {
    Database db = await instance.database;

    var result = await db.rawQuery(
        'select $table.$columnId,$table.$columnCode,$table.$columnImage, $table.$columnDesc,$table.$columnPrice,$table.$columnQuantity,$table.$columnTotal '
        'from $table');
    return result;
  }

  Future<int> delete(int id) async {
    print("id");
    print(id);
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}