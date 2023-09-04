import 'package:bloc/bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/chip/chip_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/chip/chip_event.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_event.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_state.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_event.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final Set<String> _filters;
  final Set<ChipBloc> blocList = <ChipBloc>{};
  final String name;
  final RecipeBloc recipeBloc;

  Set<String> get filters => _filters;

  FilterBloc({
    required this.name,
    required Set<String> filters,
    required this.recipeBloc,
  })  : _filters = filters,
        super(const FilterStateDefault()) {
    on<FilterEventAdd>(
      (event, emit) {
        _filters.add(event.value);
        blocList.add(event.chip);
        emit(FilterStateUpdate(length: _filters.length));
      },
    );

    on<FilterEventRemove>(
      (event, emit) {
        _filters.remove(event.value);
        blocList.remove(event.chip);
        emit(FilterStateUpdate(length: _filters.length));
      },
    );

    on<FilterEventReset>(
      (event, emit) {
        _filters.clear();
        for (var bloc in blocList) {
          bloc.add(const ChipEventUpdate(state: false));
        }
        blocList.clear();
        emit(FilterStateUpdate(length: _filters.length));
      },
    );

    on<FilterEventResetChips>(
      (event, emit) {
        blocList.clear();
      },
    );
  }

  @override
  Future<void> close() {
    recipeBloc.add(RecipeEventAddChipFilter(
      category: name,
      filters: _filters,
    ));
    return super.close();
  }
}
