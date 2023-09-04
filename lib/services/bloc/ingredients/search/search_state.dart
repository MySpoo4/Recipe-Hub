import 'package:flutter/material.dart';
import 'package:recipe_hub/util/util.dart';

abstract class SearchState {
  const SearchState();
}

class SearchStateInitial extends SearchState {
  const SearchStateInitial();
}

class SearchStateList extends SearchState {
  final Key list = UniqueKey();
  final Exception? exception;
  SearchStateList({this.exception});
}

class SearchStateAdd extends SearchState {
  final Ingredient ingredient;
  const SearchStateAdd({required this.ingredient});
}
