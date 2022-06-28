import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:order_app/model/cart.dart';
import 'package:order_app/model/order.dart';

import 'dart:async';

class DBHelp {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final contacttable = 'contacttable';

  static final carttable = 'carttable';

  static final columnId = 'id';
  static final columnCode = 'code';

  static final columnImage = 'imageurl';
  static final columnDesc = 'desc';
  static final columnUnit = 'unit';
  static final columnPrice = 'price';
  static final columnQuantity = 'quantity';
  static final columnTotal = 'total';

  static final columnDate = 'date';
  static final columnAddress = 'address';
  static final columnPhone = 'phone';
  static final columnName = 'name';

  // make this a singleton class
  DBHelp._privateConstructor();
  static final DBHelp instance = DBHelp._privateConstructor();

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
          CREATE TABLE $carttable (
            $columnId INTEGER PRIMARY KEY,
            $columnCode TEXT NOT NULL,
            $columnImage TEXT NOT NULL,  
            $columnDesc TEXT NOT NULL,
            $columnUnit TEXT NOT NULL,
            $columnPrice INTEGER,
            $columnQuantity INTEGER,
            $columnTotal INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE $contacttable (
            $columnDate TEXT NOT NULL,
            $columnAddress TEXT NOT NULL,  
            $columnPhone TEXT NOT NULL,
            $columnName TEXT NOT NULL
            )
          ''');
  }

  // Helper methods

  //product_details

  Future<int> insert(Cart cart) async {
    Database db = await instance.database;
    return await db.insert(carttable, {
      'code': cart.code,
      'imageurl': cart.imageurl,
      'desc': cart.desc,
      'unit': cart.unit,
      'price': cart.price,
      'quantity': cart.quantity,
      'total': cart.total
    });
  }

  Future<int> inserthistory(Order order) async {
    Database db = await instance.database;
    return await db.insert(contacttable, {
      'date': order.date,
      'address': order.address,
      'phone': order.phone,
      'name': order.name
    });
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(carttable);
  }

  Future<List<Map<String, dynamic>>> queryAllRowshistory() async {
    Database db = await instance.database;
    return await db.query(contacttable);
  }

  Future<int> calculateTotal() async {
    var db = await instance.database;
    int result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT SUM($columnTotal) as Total FROM $carttable"));
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
        "UPDATE $carttable SET $columnQuantity=$qty,$columnTotal=$tot WHERE desc='$desc'");
    //return await db.rawUpdate(sql)
  }

  //del all table dtls
  Future<int> deletetable() async {
    Database db = await instance.database;
    //await db.delete(carttable);
    return await db.delete(carttable);
  }

  Future<int> deletecontacttable() async {
    Database db = await instance.database;
    //await db.delete(carttable);
    return await db.delete(contacttable);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT(*) FROM $carttable');
    int count = Sqflite.firstIntValue(x);
    print(count);
    return count;
  }

  Future<int> deleterow(String desc) async {
    Database db = await instance.database;
    print("desc");
    print(desc);
    return await db
        .delete(carttable, where: '$columnDesc = ?', whereArgs: [desc]);
  }

//view cart page

  Future<List<Map<String, dynamic>>> queryDetails() async {
    Database db = await instance.database;

    var result = await db.rawQuery(
        'select $carttable.$columnId,$carttable.$columnCode,$carttable.$columnImage, $carttable.$columnDesc,$carttable.$columnUnit,$carttable.$columnPrice,$carttable.$columnQuantity,$carttable.$columnTotal '
        'from $carttable');
    return result;
  }

  Future<int> delete(int id) async {
    print("id");
    print(id);
    Database db = await instance.database;
    return await db.delete(carttable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> getlastrowid() async {
    Database db = await instance.database;
    int number = Sqflite.firstIntValue(
        await db.rawQuery("SELECT MAX($columnId) from $carttable"));
    print("last row id");
    print(number);
    return number;
  }

  Future<int> getcount(desc) async {
    print('db desc');
    print(desc);
    String c = desc.toString();
    print(c);

    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM $carttable WHERE $columnDesc='$c'"));
    //print("count");
    //print(count);
    return count;
  }

  Future<int> getquantity(desc) async {
    print('db quantity');
    print(desc);
    String c = desc.toString();
    print(c);

    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $columnQuantity FROM $carttable WHERE $columnDesc='$c'"));
    //print("count");
    //print(count);
    return count;
  }
}
