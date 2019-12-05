import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/model_complaint.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider dbProviderInstance = DBProvider._();
  static Database _database;

  Future<Database> get getDatabaseConnection async {
    print("--------inside get database connection");

    if (_database != null) return _database;

    _database = await init();
   print("=--------value of database");
    print(_database);
    return _database;
  }

  Future<Database> init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, "complaints.db");
    Database tempDb = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      print("-----Creating Table Complants");
      newDb.execute(
          "CREATE TABLE Complaints(id INTEGER PRIMARY KEY,description TEXT,grievanceType TEXT,imageURL TEXT)");
    });
    print("--------value of temp Db"+tempDb.toString());
    return tempDb ;
  }

  Future<ComplaintModel> fetchItem(int id) async {
    _database = await getDatabaseConnection;
    if(_database!=null&&_database.isOpen)
  {
      final maps = await _database.query(
      "Complaints",
      columns: null,
      where: "id= ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ComplaintModel.fromDb(maps.first);
    }
  }
    else
      print("-----database instance is null");

    return null;
  }


  Future<int> addItem(ComplaintModel cm) async {
    print("---------addItem() called");
    print("---Data of complaint model--"+"Id: "+cm.id.toString()+" grievance type : "+cm.grievanceType);

    int no;
    _database = await getDatabaseConnection;
    if(_database!=null&&_database.isOpen) {
      no = await _database.insert("Complaints", cm.toMap());
      print("-----added::"+no.toString()+" complaint to Db");
    }
    else
      print("-----database instance is null");
    return no;
  }

  Future<List<ComplaintModel>> get getAllComplaints async {
      print("-------getAllComplaints() called");
    _database = await getDatabaseConnection;
    if(_database!=null&&_database.isOpen) {
      List<Map<String, dynamic>> complaints = await _database.query(
          "Complaints",
          columns: ["id", "description", "grievanceType", "imageURL"]);
      List<ComplaintModel> complaintList = [];
      for (Map<String, dynamic> complaint in complaints) {
        complaintList.add(ComplaintModel.fromDb(complaint));
      }
    print("-------------size of complaint list-->"+complaintList.length.toString());
    return complaintList;
  }
    else
      print("-----database instance is null");

    return null;
  }

}
