import 'package:recipe_hub/util/util.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryStateUpdate extends CategoryState {
  final List<Ingredient> list;
  const CategoryStateUpdate({required this.list});
}

class CategoryStateInitialize extends CategoryState {
  const CategoryStateInitialize();
}
