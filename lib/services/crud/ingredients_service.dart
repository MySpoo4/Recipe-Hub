import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_hub/util/util.dart';
import 'package:sqflite/sqflite.dart';

import 'crud_exceptions.dart';

class IngredientsService {
  Database? _listDB;
  List<Ingredient> _ingredientsInList = [];
  late final StreamController<List<Ingredient>> _ingredientStreamController;

  // makes a singleton
  static final IngredientsService _instance = IngredientsService._internal();
  factory IngredientsService() => _instance;
  IngredientsService._internal() {
    _ingredientStreamController = StreamController<List<Ingredient>>.broadcast(
      onListen: () {
        _ingredientStreamController.sink.add(_ingredientsInList);
      },
    );
  }

  Future<void> _cacheIngredientsList() async {
    final allIngredients = await getAllIngredients();
    _ingredientsInList = allIngredients.toList();
    _ingredientStreamController.add(_ingredientsInList);
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await openSearchDatabase();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _listDB;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> createIngredient({required Ingredient item}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    try {
      final ingredientId = await db.insert(
        table,
        {
          idColumn: item.id,
          nameColumn: item.name,
          urlColumn: item.name,
          categoryColumn: item.category
        },
      );

      final ingredient = Ingredient(
        id: ingredientId,
        name: item.name,
        picURL: item.name,
        category: item.category,
      );
      _ingredientsInList.add(ingredient);
      _ingredientStreamController.add(_ingredientsInList);
    } catch (e) {
      throw CouldNotAddElement();
    }
  }

  Future<void> deleteIngredient({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      table,
      where: 'ingredient_id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteElement();
    }
  }

  Future<Iterable<Ingredient>> getAllIngredients() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final ingredients = await db.query(table);
    return ingredients
        .map((ingredientRow) => Ingredient.fromRow(ingredientRow));
  }

  Future<List<Ingredient>> getByCategory({required String category}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final ingredients = await db.query(
      table,
      where: 'category = ?',
      whereArgs: [category],
    );
    return ingredients
        .map((ingredientRow) => Ingredient.fromRow(ingredientRow))
        .toList();
  }

  Future<Map<String, List<Ingredient>>> getAllCategories() async {
    final Map<String, List<Ingredient>> map = {};
    for (String category in categories) {
      map[category] = await getByCategory(category: category);
    }
    return map;
  }

  Future<void> openSearchDatabase() async {
    if (_listDB != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, 'dbList.db');
      final db = await openDatabase(dbPath);
      _listDB = db;
      //creates the table in database
      await db.execute(createIngredientTable);
      //cache
      await _cacheIngredientsList();
    } catch (e) {
      throw UnableToOpenDatabaseException();
    }
  }

  Future<void> closeListDatabase() async {
    final db = _listDB;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _listDB = null;
    }
  }
}

const createIngredientTable = '''CREATE TABLE IF NOT EXISTS "ingredientsList" (
	"ingredient_name"	TEXT NOT NULL UNIQUE,
	"ingredient_id"	INTEGER NOT NULL UNIQUE,
	"image_url"	TEXT,
  "category" TEXT NOT NULL,
	PRIMARY KEY("ingredient_id")
);
''';

const table = 'ingredientsList';
