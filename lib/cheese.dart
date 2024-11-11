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
    if (_database != null ) {return _database!;}
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

// CheeseCard widget to display cheese information.
class CheeseCard extends StatelessWidget {
  final Cheese cheese; // current cheese to be displayed

  const CheeseCard({super.key, required this.cheese});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              cheese.imagePath,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              cheese.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Origin: ${cheese.origin}'),
            const SizedBox(height: 5),
            Text('Aging Window: ${cheese.agingWindow} months'),
            const SizedBox(height: 5),
            Text('Animal: ${cheese.animal.join(', ')}'),
            const SizedBox(height: 5),
            Text('Traditionally Raw: ${cheese.traditionallyRaw}'),
            const SizedBox(height: 5),
            Text('Flavor Profile: ${cheese.flavorProfile.join(', ')}'),
            const SizedBox(height: 5),
            Text('Texture: ${cheese.texture.join(', ')}'),
            const SizedBox(height: 5),
            Text('Usage: ${cheese.usage.join(', ')}'),
            const SizedBox(height: 5),
            Text('History: ${cheese.history}'),
          ],
        ),
      ),
    );
  }
}

void insertSampleCheeses() async {
  // Creating sample cheeses
  final sampleCheeses = [
    Cheese(
      name: 'Brie',
      origin: 'France',
      agingWindow: '4-5 weeks',
      animal: ['Cow'],
      traditionallyRaw: true,
      flavorProfile: ['Creamy', 'Nutty', 'Mild'],
      texture: ['Soft', 'Creamy'],
      usage: ['Cheese Board', 'Sandwiches', 'Baked Dishes'],
      history: 'Brie is a soft cheese that originated in the Île-de-France region.',
      imagePath: 'assets/images/brie.jpg', // Adjust with actual image asset path
    ),
    Cheese(
      name: 'Cheddar',
      origin: 'England',
      agingWindow: '3-12 months',
      animal: ['Cow'],
      traditionallyRaw: false,
      flavorProfile: ['Sharp', 'Tangy', 'Rich'],
      texture: ['Firm', 'Crumbly'],
      usage: ['Cheese Board', 'Grilled Cheese', 'Burgers'],
      history: 'Cheddar cheese originated in the village of Cheddar, England.',
      imagePath: 'assets/images/cheddar.jpg', // Adjust with actual image asset path
    ),
    Cheese(
      name: 'Gorgonzola',
      origin: 'Italy',
      agingWindow: '3-6 months',
      animal: ['Cow'],
      traditionallyRaw: true,
      flavorProfile: ['Salty', 'Pungent', 'Sharp'],
      texture: ['Soft', 'Crumbly'],
      usage: ['Salads', 'Pasta', 'Cheese Boards'],
      history: 'Gorgonzola is a blue cheese from Italy with a distinct, bold flavor.',
      imagePath: 'assets/images/gorgonzola.jpg', // Adjust with actual image asset path
    ),
    Cheese(
      name: 'Parmesan',
      origin: 'Italy',
      agingWindow: '12-36 months',
      animal: ['Cow'],
      traditionallyRaw: false,
      flavorProfile: ['Nutty', 'Salty', 'Umami'],
      texture: ['Hard', 'Granular'],
      usage: ['Grated on Pasta', 'Soups', 'Salads'],
      history: 'Parmigiano Reggiano is a hard, granular cheese from Italy.',
      imagePath: 'assets/images/parmesan.jpg', // Adjust with actual image asset path
    ),
  ];

  // Inserting sample cheeses into the database
  final db = await CheeseDatabase.instance.database;

  for (var cheese in sampleCheeses) {
    await db.insert('cheeses', cheese.toMap());
  }

  print('Sample cheeses inserted successfully!');
}

