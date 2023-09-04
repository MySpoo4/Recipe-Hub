import 'package:bloc/bloc.dart';
import 'package:recipe_hub/services/bloc/ingredients/search/search_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_bloc.dart';

class BlocCubit extends Cubit<void> {
  final RecipeBloc recipeBloc;
  final SearchBloc searchBloc;
  final SavedBloc savedBloc;

  BlocCubit({
    required this.recipeBloc,
    required this.searchBloc,
    required this.savedBloc,
  }) : super(null);

  @override
  Future<void> close() {
    recipeBloc.close();
    searchBloc.close();
    savedBloc.close();
    return super.close();
  }
}
