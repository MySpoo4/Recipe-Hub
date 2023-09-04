import 'package:flutter/material.dart';

abstract class RecipeEvent {
  const RecipeEvent();
}

class RecipeEventInit extends RecipeEvent {
  const RecipeEventInit();
}

class RecipeEventAPI extends RecipeEvent {
  const RecipeEventAPI();
}

class RecipeEventQuery extends RecipeEvent {
  final String query;
  const RecipeEventQuery({required this.query});
}

class RecipeEventLoadMore extends RecipeEvent {
  const RecipeEventLoadMore();
}

class RecipeEventAddChipFilter extends RecipeEvent {
  final String category;
  final Set<String> filters;
  const RecipeEventAddChipFilter({
    required this.category,
    required this.filters,
  });
}

class RecipeEventAddRangeFilter extends RecipeEvent {
  final String category;
  final RangeValues range;
  const RecipeEventAddRangeFilter({
    required this.category,
    required this.range,
  });
}

class RecipeEventResetAll extends RecipeEvent {
  const RecipeEventResetAll();
}
