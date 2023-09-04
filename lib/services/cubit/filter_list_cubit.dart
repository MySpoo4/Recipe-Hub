import 'package:bloc/bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_event.dart';
import 'package:recipe_hub/services/bloc/recipe/range_slider/range_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/range_slider/range_event.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_event.dart';

class FilterListCubit extends Cubit<void> {
  final List<FilterBloc> filterList = [];
  final List<RangeBloc> rangeList = [];
  final List<String> stringList = [];
  final RecipeBloc recipeBloc;
  FilterListCubit({required this.recipeBloc}) : super(null);

  void reset() {
    recipeBloc.add(const RecipeEventResetAll());
    for (var bloc in filterList) {
      if (!bloc.isClosed) {
        bloc.add(const FilterEventReset());
      }
    }
    for (var bloc in rangeList) {
      if (!bloc.isClosed) {
        bloc.add(const RangeEventResetRange());
      }
    }
  }
}
