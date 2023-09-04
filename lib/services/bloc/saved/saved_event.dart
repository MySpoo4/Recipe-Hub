import 'package:recipe_hub/util/util.dart';

abstract class SavedEvent {
  const SavedEvent();
}

class SavedEventRemove extends SavedEvent {
  final String uri;
  const SavedEventRemove({required this.uri});
}

class SavedEventAdd extends SavedEvent {
  final RecipeInfo recipeInfo;
  const SavedEventAdd({required this.recipeInfo});
}

class SavedEventInit extends SavedEvent {
  const SavedEventInit();
}
