// Database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:cheese_shoppe/CheeseDao.dart';
import 'package:cheese_shoppe/Cheese.dart';

part 'Database.g.dart';

@Database(version: 1, entities: [Cheese])
abstract class AppDatabase extends FloorDatabase {
  CheeseDao get cheeseDao;
}