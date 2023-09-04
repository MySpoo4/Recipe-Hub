import 'package:flutter/material.dart';

abstract class RecipeState {
  const RecipeState();
}

class RecipeStateList extends RecipeState {
  final Key key = UniqueKey();
  RecipeStateList();
}

class RecipeStateLoadMore extends RecipeState {
  final Key key = UniqueKey();
  RecipeStateLoadMore();
}

class RecipeStateDefault extends RecipeState {
  const RecipeStateDefault();
}

class RecipeStateNoneFound extends RecipeState {
  const RecipeStateNoneFound();
}
