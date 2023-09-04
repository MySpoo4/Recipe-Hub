import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/range_slider/range_event.dart';
import 'package:recipe_hub/services/bloc/recipe/range_slider/range_state.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_event.dart';

const double start = 0;
const double end = 3000;

class RangeBloc extends Bloc<RangeEvent, RangeState> {
  RangeValues _range = const RangeValues(start, end);
  final String name;
  final RecipeBloc recipeBloc;

  RangeValues get range => _range;

  RangeBloc({
    required this.name,
    required range,
    required this.recipeBloc,
  })  : _range = range,
        super(const RangeStateDefault()) {
    on<RangeEventUpdate>(
      (event, emit) {
        _range = event.range;
        emit(RangeStateUpdate(range: event.range));
      },
    );

    on<RangeEventResetRange>(
      (event, emit) {
        _range = const RangeValues(start, end);
        emit(RangeStateUpdate(range: _range));
      },
    );
  }
  @override
  Future<void> close() {
    recipeBloc.add(RecipeEventAddRangeFilter(
      category: name,
      range: _range,
    ));
    return super.close();
  }
}
