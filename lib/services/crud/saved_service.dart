import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_hub/util/util.dart';
import 'package:sqflite/sqflite.dart';

import 'crud_exceptions.dart';

class SaveService {
  Database? _recipeDB;
  List<RecipeInfo> _recipesInList = [];

  List<RecipeInfo> get recipeList => _recipesInList;

  // makes a singleton
  static final SaveService _instance = SaveService._internal();
  factory SaveService() => _instance;
  SaveService._internal();

  Future<void> _cacheRecipeList() async {
    final allRecipes = getAllRecipes();
    _recipesInList = await allRecipes;
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await openSearchDatabase();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _recipeDB;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> createRecipe({required RecipeInfo item}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    try {
      await db.insert(
        table,
        {
          recipeNameColumn: item.name,
          recipeUriColumn: item.uri,
          recipeImageColumn: item.imageUrl,
          recipeSourceColumn: item.source,
          servingsColumn: item.servings,
          caloriesPerServingColumn: item.caloriesPerServing,
          dietLabelsColumn: item.dietLabels.join('|'),
          ingredientsColumn: item.ingredients.join('|'),
          ingredientsImageColumn: item.ingredientImage.join('|'),
        },
      );

      _recipesInList.add(item);
    } catch (e) {
      throw CouldNotAddElement();
    }
  }

  Future<void> deleteRecipe({required String uri}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      table,
      where: 'uri = ?',
      whereArgs: [uri],
    );
    _recipesInList.removeWhere((RecipeInfo element) => element.uri == uri);
    if (deletedCount != 1) {
      throw CouldNotDeleteElement();
    }
  }

  Future<List<RecipeInfo>> getAllRecipes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final recipes = await db.query(table);
    return recipes.map((recipeRow) => RecipeInfo.fromRow(recipeRow)).toList();
  }

  Future<void> openSearchDatabase() async {
    if (_recipeDB != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, 'dbRecipe.db');
      final db = await openDatabase(dbPath);
      _recipeDB = db;
      //creates the table in database
      await db.execute(createRecipeTable);
      //cache
      await _cacheRecipeList();
    } catch (e) {
      throw UnableToOpenDatabaseException();
    }
  }

  Future<void> closeListDatabase() async {
    final db = _recipeDB;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _recipeDB = null;
    }
  }
}

const createRecipeTable = '''CREATE TABLE IF NOT EXISTS "recipeList" (
	"recipe_name"	TEXT NOT NULL,
	"uri"	TEXT NOT NULL UNIQUE,
	"imageUrl"	TEXT NOT NULL,
	"source"	TEXT NOT NULL,
	"servings"	INTEGER NOT NULL,
	"caloriesPerServing"	INTEGER NOT NULL,
	"dietLabels"	TEXT,
	"ingredients"	TEXT,
	"ingredientsImage"	TEXT
);
''';

const table = 'recipeList';
