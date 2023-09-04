import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_hub/services/api/api_exceptions.dart';
import 'package:recipe_hub/util/util.dart';

const apiUrl = 'https://api.edamam.com/api/recipes/v2';
const String type = 'any';

class RecipeService {
  List<RecipeInfo> _recipeList = [];
  String? nextPage = '';
  BaseRecipeQuery? prevQuery;

  static final RecipeService _instance = RecipeService._internal();
  factory RecipeService() => _instance;
  RecipeService._internal();

  List<RecipeInfo> get recipeList => _recipeList;

  Future<List<RecipeInfo>> fetchNext() async {
    if (nextPage != null) {
      final url = Uri.parse(nextPage!);
      try {
        final response = await http.get(url);
        final body = response.body;
        final json = jsonDecode(body);
        nextPage = json['_links']['next']['href'];
        final rawList = json['hits'];
        final List<RecipeInfo> list = rawList.map<RecipeInfo>((element) {
          final recipe = element['recipe'];
          return RecipeInfo(
            uri: recipe['uri'],
            name: recipe['label'],
            imageUrl: recipe['images']['REGULAR']['url'],
            source: recipe['url'],
            servings: recipe['yield'].round(),
            caloriesPerServing: recipe['calories'].round(),
            dietLabels: recipe['dietLabels'].cast<String>(),
            ingredients: recipe['ingredientLines'].cast<String>(),
            ingredientImage: recipe['ingredients']
                .map((map) => map['image'] ?? '')
                .toList()
                .cast<String>(),
          );
        }).toList();
        _recipeList.addAll(list);
        return list;
      } catch (e) {
        rethrow;
      }
    } else {
      throw NoNextPageException();
    }
  }

  Future<List<RecipeInfo>> fetchRecipes({
    required BaseRecipeQuery query,
  }) async {
    if (prevQuery?.queryString != query.queryString) {
      _recipeList = [];
      nextPage = '';
      final url = Uri.parse(apiUrl).replace(query: query.queryString);
      try {
        final response = await http.get(url);
        final body = response.body;
        final json = jsonDecode(body);
        nextPage =
            json['_links'] == null ? '' : json['_links']?['next']?['href'];
        final rawList = json['hits'];
        if (rawList != null) {
          final List<RecipeInfo> list = rawList.map<RecipeInfo>((element) {
            final recipe = element['recipe'];
            return RecipeInfo(
              uri: recipe['uri'],
              name: recipe['label'],
              imageUrl: recipe['images']['REGULAR']['url'],
              source: recipe['url'],
              servings: recipe['yield'].round(),
              caloriesPerServing: recipe['calories'].round(),
              dietLabels: recipe['dietLabels'].cast<String>(),
              ingredients: recipe['ingredientLines'].cast<String>(),
              ingredientImage: recipe['ingredients']
                  .map((map) => map['image'] ?? '')
                  .toList()
                  .cast<String>(),
            );
          }).toList();
          _recipeList.addAll(list);
          return _recipeList;
        } else {
          return [];
        }
      } catch (e) {
        rethrow;
      }
    } else {
      return _recipeList;
    }
  }
}
