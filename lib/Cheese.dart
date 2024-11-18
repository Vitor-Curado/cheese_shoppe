import 'package:floor/floor.dart';

// Model representing an entry
@entity
class Cheese {
  @primaryKey
  final int? id;
  String name;
  String origin;
  String agingWindow;
  String animal;
  bool traditionallyRaw;
  String flavorProfile;
  String texture;
  String usage;
  String history;
  String imagePath;

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

  void setName(String name) {
    this.name = name;
  }

  void setOrigin(String origin) {
    this.origin = origin;
  }

  // Converts cheese objects to a Map<String, dynamic> for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'agingWindow': agingWindow,
      'animal': animal,
      'traditionallyRaw': traditionallyRaw,
      'flavorProfile': flavorProfile,
      'texture': texture,
      'usage': usage,
      'history': history,
      'imagePath': imagePath
    };
  }

  // Creates a database from a map, typically returned by a database query
  factory Cheese.fromMap(Map<String, dynamic> map) {
    return Cheese(
      id: map['id'],
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
