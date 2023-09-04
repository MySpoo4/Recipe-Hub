import 'package:recipe_hub/services/crud/ingredients_service.dart';
import 'package:recipe_hub/util/util.dart';

abstract class CategoryEvent {
  const CategoryEvent();
}

class CategoryEventUpdate extends CategoryEvent {
  final String category;
  const CategoryEventUpdate({required this.category});
}

class CategoryEventRemove extends CategoryEvent {
  final Ingredient ingredient;
  const CategoryEventRemove({required this.ingredient});
}

class CategoryEventInitialize extends CategoryEvent {
  final IngredientsService service;
  const CategoryEventInitialize({required this.service});
}
