import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:recipe_hub/services/crud/crud_exceptions.dart';
import 'package:recipe_hub/util/util.dart';
import 'package:sqflite/sqflite.dart';

class SearchService {
  Database? _searchDB;
  List<Ingredient> _ingredients = [];
  late final StreamController<List<Ingredient>> _ingredientStreamController;

  // makes a singleton
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal() {
    _ingredientStreamController = StreamController<List<Ingredient>>.broadcast(
      onListen: () {
        _ingredientStreamController.sink.add(_ingredients);
      },
    );
  }

  Future<void> _cacheIngredients() async {
    final allIngredients = await getAllIngredients();
    _ingredients = allIngredients.toList();
    _ingredientStreamController.add(_ingredients);
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await openSearchDatabase();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _searchDB;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  // load the previous one so no need to delete
  Future<void> openSearchDatabase() async {
    if (_searchDB != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, "copy.db");
      // Check if the database exists
      var exists = await databaseExists(path);
      if (!exists) {
        // Should happen only the first time you launch your application
        // Make sure the parent directory exists
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}

        // Copy from asset
        ByteData data = await rootBundle.load(join("assets", "db.db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);
      }
      // open the database
      _searchDB = await openDatabase(path, readOnly: true);
      _cacheIngredients();
    } catch (e) {
      throw UnableToOpenDatabaseException();
    }
  }

  Future<void> closeSearchDatabase() async {
    final db = _searchDB;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _searchDB = null;
    }
  }

  Future<List<Ingredient>> getIngredients({required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final ingredients = await db
        .rawQuery('''SELECT * FROM $table WHERE $nameColumn LIKE '%$text%'
      ''');
    if (ingredients.isEmpty) {
      throw CouldNotFindElement();
    } else {
      final list = ingredients
          .map((ingredientRow) => Ingredient.fromRow(ingredientRow))
          .toList();
      return list;
    }
  }

  Future<Iterable<Ingredient>> getAllIngredients() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final ingredients = await db.query(table);
    return ingredients
        .map((ingredientRow) => Ingredient.fromRow(ingredientRow));
  }
}

const table = 'ingredients';
