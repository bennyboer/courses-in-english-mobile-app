import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Campus(id INTEGER PRIMARY KEY, name TEXT, imagePath TEXT)");
    await db.execute(
        "CREATE TABLE Course(id INTEGER PRIMARY KEY, name TEXT, location TEXT, description TEXT, department INTEGER, lecturerId INTEGER, lecturerName TEXT, room TEXT, status TEXT, availableSlots INTEGER, ects INTEGER, time TEXT, day TEXT )");
    await db.execute(
        "CREATE TABLE Department(id INTEGER PRIMARY KEY, number INTEGER, name TEXT, color String)");
    await db.execute(
        "CREATE TABLE Favorites(id INTEGER PRIMARY KEY, classname TEXT, note TEXT)");
    await db.execute(
        "CREATE TABLE Lecturer(id INTEGER PRIMARY KEY, name TEXT, email TEXT)");
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, firstname TEXT, lastname TEXT, department INTEGER)");
  }

//insertion
  Future<int> saveCampus(String name, String imagePath) async {
    var dbClient = await db;
    Map<String, dynamic> tempCampus = new Map();
    tempCampus["name"] = name;
    tempCampus["imagePath"] = imagePath;
    int res = await dbClient.insert("Campus", tempCampus); //Fix to map
    return res;
  }

  Future<List<Map<String, dynamic>>> selectTable(String table) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res =
        await dbClient.rawQuery('SELECT * FROM $table');
    return res;
  }
}