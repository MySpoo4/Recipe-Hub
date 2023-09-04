import 'package:recipe_hub/services/bloc/nav/nav_event.dart';
import 'package:recipe_hub/services/bloc/nav/nav_state.dart';
import 'package:bloc/bloc.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  int _index;
  int get index => _index;

  NavBloc({int index = 0})
      : _index = index,
        super(NavStateUpdate(index: index)) {
    on<NavEventIndex>(
      (event, emit) {
        if (_index != event.index) {
          _index = event.index;
          emit(NavStateUpdate(index: event.index));
        }
      },
    );
  }
}
