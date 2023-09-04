import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hub/services/api/api_exceptions.dart';
import 'package:recipe_hub/services/api/recipe_api.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_event.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_state.dart';
import 'package:recipe_hub/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeService service;
  final List<RecipeInfo> _recipeList = [];
  late final String apiKey;
  late final String appId;
  bool apiInit = false;
  List<RecipeInfo> get recipeList => _recipeList;

  final Map<String, Set<String>> chipFilter = <String, Set<String>>{
    'Ingredients': {},
    'Diet': {},
    'Meal Type': {},
    'Health': {},
    'Cuisine Type': {},
    'Dish Type': {},
  };
  final Map<String, RangeValues> rangeFilter = <String, RangeValues>{
    'Calories Range': const RangeValues(0, 3000),
  };

  RecipeBloc({required this.service}) : super(const RecipeStateDefault()) {
    on<RecipeEventInit>(
      (event, emit) {
        if (service.recipeList.isNotEmpty) {
          _recipeList.clear();
          _recipeList.addAll(service.recipeList);
          emit(RecipeStateList());
        }
      },
    );

    on<RecipeEventAPI>(
      (event, emit) async {
        if (!apiInit) {
          apiInit = true;
          final prefs = await SharedPreferences.getInstance();
          apiKey = prefs.getString('API_KEY')!;
          appId = prefs.getString('APP_ID')!;
        }
      },
    );

    on<RecipeEventQuery>(
      (event, emit) async {
        final recipeQuery = BaseRecipeQuery(
          apiKey: apiKey,
          appId: appId,
          useIngredients: chipFilter['Ingredients']!.isNotEmpty,
          ingredients: chipFilter['Ingredients']!,
          query: event.query,
          diet: chipFilter['Diet']!,
          mealType: chipFilter['Meal Type']!,
          health: chipFilter['Health']!,
          dishType: chipFilter['Dish Type']!,
          cuisine: chipFilter['Cuisine Type']!,
          calories: rangeFilter['Calories Range']!,
        );

        final list = await service.fetchRecipes(query: recipeQuery);
        if (list.isEmpty) {
          emit(const RecipeStateNoneFound());
        } else {
          _recipeList.clear();
          _recipeList.addAll(list);
          emit(RecipeStateList());
        }
      },
    );

    on<RecipeEventLoadMore>(
      (event, emit) async {
        try {
          final list = await service.fetchNext();
          _recipeList.addAll(list);
          emit(RecipeStateLoadMore());
        } on NoNextPageException {
          //empty
        }
      },
    );

    on<RecipeEventAddChipFilter>(
      (event, emit) {
        chipFilter[event.category] = event.filters;
      },
    );

    on<RecipeEventAddRangeFilter>(
      (event, emit) {
        rangeFilter[event.category] = event.range;
      },
    );

    on<RecipeEventResetAll>(
      (event, emit) {
        chipFilter.forEach((key, value) {
          value.clear();
        });
        rangeFilter.forEach((key, value) {
          value = const RangeValues(0, 3000);
        });
      },
    );
  }
}
