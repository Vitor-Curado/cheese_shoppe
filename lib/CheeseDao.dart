import 'package:floor/floor.dart';
import 'Cheese.dart';

@dao
abstract class CheeseDao {
  @insert
  Future<int> insertCheese(Cheese cheese);

  @Query('SELECT * FROM cheese')
  Future<List<Cheese>> getAllCheeses();

  @delete
  Future<int> deleteCheese(Cheese cheese);

  @update
  Future<int> updateCheese(Cheese cheese);
}
