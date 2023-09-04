import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/chip/chip_event.dart';
import 'package:recipe_hub/services/bloc/recipe/chip/chip_state.dart';

class ChipBloc extends Bloc<ChipEvent, ChipState> {
  ChipBloc() : super(const ChipStateDefault()) {
    on<ChipEventUpdate>(
      (event, emit) {
        emit(ChipStateUpdate(state: event.state));
      },
    );
  }
}
