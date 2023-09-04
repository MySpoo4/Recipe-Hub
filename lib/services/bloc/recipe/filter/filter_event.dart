import 'package:recipe_hub/services/bloc/recipe/chip/chip_bloc.dart';

abstract class FilterEvent {
  const FilterEvent();
}

class FilterEventAdd extends FilterEvent {
  final String value;
  final ChipBloc chip;
  const FilterEventAdd({
    required this.value,
    required this.chip,
  });
}

class FilterEventRemove extends FilterEvent {
  final String value;
  final ChipBloc chip;
  const FilterEventRemove({
    required this.value,
    required this.chip,
  });
}

class FilterEventReset extends FilterEvent {
  const FilterEventReset();
}

class FilterEventResetChips extends FilterEvent {
  const FilterEventResetChips();
}
