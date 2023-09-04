import 'package:bloc/bloc.dart';
import 'package:recipe_hub/services/bloc/ingredients/category/category_event.dart';
import 'package:recipe_hub/services/bloc/ingredients/category/category_state.dart';
import 'package:recipe_hub/services/crud/ingredients_service.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  late final IngredientsService service;
  bool isInitalized = false;
  CategoryBloc() : super(const CategoryStateInitialize()) {
    on<CategoryEventUpdate>(
      (event, emit) async {
        final list = await service.getByCategory(category: event.category);
        emit(CategoryStateUpdate(list: list));
      },
    );

    on<CategoryEventRemove>(
      (event, emit) async {
        service.deleteIngredient(id: event.ingredient.id);
        final list =
            await service.getByCategory(category: event.ingredient.category);
        emit(CategoryStateUpdate(list: list));
      },
    );

    on<CategoryEventInitialize>(
      (event, emit) {
        if (!isInitalized) {
          service = event.service;
          isInitalized = true;
        }
      },
    );
  }
}
