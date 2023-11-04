import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'item_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _name = "Inventory.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _name),
        onCreate: (db, version) async {
      return db.execute(
          "CREATE TABLE Inventory(id INTEGER PRIMARY KEY, name TEXT, category TEXT, image TEXT, givenAway INTEGER)");
    }, version: _version);
  }

  static Future<int> insert(InventoryItem item) async {
    Database db = await _getDB();

    return db.insert("Inventory", item.toJson());
  }

  static Future<List<InventoryItem>> retrieveItems() async {
    Database db = await _getDB();
    List<Map<String, dynamic>> json = await db.query("Inventory");
    List<InventoryItem> x = List.generate(json.length, (index) {
      return InventoryItem.fromJson(json[index]);
    });

    return x;
  }

  static Future<int> delete(InventoryItem item) async {
    Database db = await _getDB();
    return db.delete("Inventory", where: "id = ?", whereArgs: [item.id]);
  }

  static Future<int> update(InventoryItem item) async {
    Database db = await _getDB();
    return db.update("Inventory", item.toJson(),
        where: "id = ?", whereArgs: [item.id]);
  }
}
