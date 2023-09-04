import 'package:flutter/material.dart';
import 'package:recipe_hub/view/pages/recipe/components/calories_tile.dart';
import 'package:recipe_hub/view/pages/recipe/components/ingredients_tile.dart';
import 'package:recipe_hub/view/pages/recipe/filter_list/filter_lists.dart';

final List<Item> data = [
  Item(
    headerValue: 'Ingredients',
    widget: const IngredientsTile(name: 'Ingredients'),
    special: true,
  ),
  Item(
    headerValue: 'Diet',
    expandedValue: dietList,
  ),
  Item(
    headerValue: 'Meal Type',
    expandedValue: mealList,
  ),
  Item(
    headerValue: 'Health',
    expandedValue: healthList,
  ),
  Item(
    headerValue: 'Cuisine Type',
    expandedValue: cuisineList,
  ),
  Item(
    headerValue: 'Dish Type',
    expandedValue: dishList,
  ),
  Item(
    headerValue: 'Calories Range',
    widget: const CaloriesTile(name: 'Calories Range'),
    special: true,
  ),
];

// class
class Item {
  final String headerValue;
  final List<String>? expandedValue;
  final Widget? widget;
  final bool special;

  Item({
    required this.headerValue,
    this.expandedValue,
    this.widget,
    this.special = false,
  });
}
