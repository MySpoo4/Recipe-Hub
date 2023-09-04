import 'package:flutter/material.dart';

Color getCategoryColor(String category) {
  switch (category) {
    case 'produce':
      return const Color.fromARGB(255, 174, 227, 176); // Green
    case 'dairy':
      return const Color.fromARGB(255, 241, 241, 116); // Yellow
    case 'meat':
      return const Color.fromARGB(255, 204, 129, 129); // Red
    case 'grains':
      return const Color.fromARGB(255, 210, 180, 140); // Light Brown
    case 'spice_seasonings':
      return const Color.fromARGB(255, 232, 164, 61); // Orange
    case 'sauces_condiments':
      return const Color.fromARGB(255, 200, 101, 101); // Dark Red
    case 'beverage':
      return const Color.fromARGB(255, 91, 150, 199);
    case 'snacks':
      return const Color.fromARGB(255, 169, 169, 169); // Gray
    default:
      return Colors.white; // Default color if the category is not recognized
  }
}

String getCategory({required String category}) {
  if (category == 'sauces_condiments' || category == 'spice_seasonings') {
    return category.replaceAll('_', '\n');
  }
  return category;
}

class Ingredient {
  final int id;
  final String name;
  final String picURL;
  final String category;

  Ingredient({
    required this.id,
    required this.name,
    required this.picURL,
    required this.category,
  });

  Ingredient.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        picURL = map[urlColumn] as String,
        category = map[categoryColumn] as String;
}

const idColumn = 'ingredient_id';
const nameColumn = 'ingredient_name';
const urlColumn = 'image_url';
const categoryColumn = 'category';

const apiUrl = 'https://api.edamam.com/api/recipes/v2';

const String type = 'any';

class BaseRecipeQuery {
  late final String queryString;
  BaseRecipeQuery({
    required String apiKey,
    required String appId,
    required bool useIngredients,
    required String query,
    Set<String> ingredients = const {},
    Set<String> diet = const {},
    Set<String> mealType = const {},
    Set<String> health = const {},
    Set<String> dishType = const {},
    Set<String> cuisine = const {},
    required RangeValues calories,
  }) {
    final List<String> queryList = [];
    queryList.addAll([
      'type=$type',
      'app_id=$appId',
      'app_key=$apiKey',
    ]);
    if (useIngredients) {
      queryList.add('q=$query%20${ingredients.join('%20')}');
    } else {
      queryList.add('q=$query');
    }
    if (diet.isNotEmpty) {
      for (var element in diet) {
        queryList.add('diet=$element');
      }
    }
    if (mealType.isNotEmpty) {
      for (var element in mealType) {
        queryList.add('mealType=$element');
      }
    }
    if (health.isNotEmpty) {
      for (var element in health) {
        queryList.add('health=$element');
      }
    }
    if (dishType.isNotEmpty) {
      for (var element in dishType) {
        queryList.add('dishType=$element');
      }
    }
    if (cuisine.isNotEmpty) {
      for (var element in cuisine) {
        queryList.add('cuisineType=$element');
      }
    }
    queryList.add('calories=${calories.start}-${calories.end}');
    queryString = queryList.join('&');
  }
}

class RecipeInfo {
  final String uri;
  final String name;
  final String imageUrl;
  final String source;
  final int servings;
  final int caloriesPerServing;
  final List<String> dietLabels;
  final List<String> ingredients;
  final List<String> ingredientImage;
  const RecipeInfo({
    required this.uri,
    required this.name,
    required this.imageUrl,
    required this.source,
    required this.servings,
    required this.caloriesPerServing,
    required this.dietLabels,
    required this.ingredients,
    required this.ingredientImage,
  });

  RecipeInfo.fromRow(Map<String, Object?> map)
      : uri = map[recipeUriColumn] as String,
        name = map[recipeNameColumn] as String,
        imageUrl = map[recipeImageColumn] as String,
        source = map[recipeSourceColumn] as String,
        servings = map[servingsColumn] as int,
        caloriesPerServing = map[caloriesPerServingColumn] as int,
        dietLabels = (map[dietLabelsColumn] as String)
            .split('|')
            .where((element) => element.isNotEmpty)
            .toList(),
        ingredients = (map[ingredientsColumn] as String).split('|'),
        ingredientImage = (map[ingredientsImageColumn] as String).split('|');
}

const recipeNameColumn = 'recipe_name';
const recipeUriColumn = 'uri';
const recipeImageColumn = 'imageUrl';
const recipeSourceColumn = 'source';
const servingsColumn = 'servings';
const caloriesPerServingColumn = 'caloriesPerServing';
const dietLabelsColumn = 'dietLabels';
const ingredientsColumn = 'ingredients';
const ingredientsImageColumn = 'ingredientsImage';

List<String> categories = [
  'produce',
  'dairy',
  'meat',
  'grains',
  'spice_seasonings',
  'sauces_condiments',
  'beverage',
  'snacks',
  'miscellaneous'
];
