import 'package:flutter/material.dart';

// SQLite
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model representing an entry
class Cheese {
  final int? id;
  final String name;
  final String origin;
  final String agingWindow;
  final List<String> animal;
  final bool traditionallyRaw;
  final List<String> flavorProfile;
  final List<String> texture;
  final List<String> usage;
  final String history;
  final String imagePath;

  // Constructor
  Cheese({
    this.id,
    required this.name,
    required this.origin,
    required this.agingWindow,
    required this.animal,
    required this.traditionallyRaw,
    required this.flavorProfile,
    required this.texture,
    required this.usage,
    required this.history,
    required this.imagePath,
  });

  // Converts cheese objects to a Map<String, dynamic> for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'agingWindow': agingWindow,
      'animal': animal.join(','),
      'traditionallyRaw': traditionallyRaw,
      'flavorProfile': flavorProfile.join(','),
      'texture': texture.join(','),
      'usage': usage.join(','),
      'history': history,
      'imagePath': imagePath
    };
  }

  // Creates a database from a map, typically returned by a database query
  factory Cheese.fromMap(Map<String, dynamic> map) {
    return Cheese(
      id: map['id'] ,
      name: map['name'],
      origin: map['origin'],
      agingWindow: map['agingWindow'],
      animal: map['animal'].split(','),
      traditionallyRaw: map['traditionallyRaw'] == 1, // necessary, it converts integer to bool
      flavorProfile: map['flavorProfile'].split(','),
      texture: map['texture'].split(','),
      usage: map['usage'].split(','),
      history: map['history'],
      imagePath: map['imagePath'],
    );
  }
}

// DB
class CheeseDatabase {

  // Singleton instance of database
  static final CheeseDatabase instance = CheeseDatabase._init();

  // Private variable to use database instance
  static Database? _database;

  // Private constructor for singleton
  CheeseDatabase._init();

  // Getter for database instance, initialising it if not yet created
  Future<Database> get database async {
    // the ! is a "we're sure this thing is not null" operator
    // it won't work without it.
    // I tried.
    if (_database != null) {return _database!;}
    _database = await initDB('cheese.db');
    return _database!;
  }

  // Initialise the DB, setting up the path and creating tables if needed
  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // opens the DB, runs createDB if my boy doesn't exist
    return openDatabase(path, version: 1, onCreate: createDB);
  }

  // Creates the 'cheeses' table
  Future<void> createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE cheeses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      origin TEXT,
      agingWindow TEXT,
      animal TEXT,
      traditionallyRaw INTEGER,
      flavorProfile TEXT,
      texture TEXT,
      usage TEXT,
      history TEXT,
      imagePath TEXT
      )
      ''');
    } catch (e) {
      print('Problem creating DB: $e');
    }
  }

  // Inserts a cheese into the 'cheeses' table
  Future<void> insertCheese(Cheese cheese) async {
    try {
      final db = await instance.database;
      await db.insert('cheeses', cheese.toMap());
    } catch (e) {
      print('Problem inserting cheese: $e');
    }
  }

  // loads all cheeses from the database and maps them to the Cheese object
  Future<List<Cheese>> loadCheeses() async {
    // If not initialise it as empty, problemo.
    List<Cheese> result = [];
    try {
      final db = await instance.database;
      final maps = await db.query('cheeses');
      result = maps.map((map) => Cheese.fromMap(map)).toList();
    } catch (e) {
      print('Problem loading cheeses: $e');
    }

    return result;
  }

  // You can guess what this one does.
  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
