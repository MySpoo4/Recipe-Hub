import 'package:bloc/bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_event.dart';
import 'package:recipe_hub/services/bloc/saved/saved_state.dart';
import 'package:recipe_hub/services/crud/saved_service.dart';
import 'package:recipe_hub/util/util.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final SaveService service;
  final List<RecipeInfo> list = [];
  SavedBloc({required this.service}) : super(const SavedStateDefault()) {
    on<SavedEventAdd>(
      (event, emit) {
        service.createRecipe(item: event.recipeInfo);
        list.add(event.recipeInfo);
        emit(SavedStateUpdate());
      },
    );

    on<SavedEventRemove>(
      (event, emit) {
        service.deleteRecipe(uri: event.uri);
        list.removeWhere((RecipeInfo element) => element.uri == event.uri);
        emit(SavedStateUpdate());
      },
    );

    on<SavedEventInit>(
      (event, emit) async {
        list.clear();
        list.addAll(await service.getAllRecipes());
        emit(SavedStateUpdate());
      },
    );
  }

  bool contains(RecipeInfo bloc) {
    for (RecipeInfo item in list) {
      if (item.uri == bloc.uri) {
        return true;
      }
    }
    return false;
  }
}
