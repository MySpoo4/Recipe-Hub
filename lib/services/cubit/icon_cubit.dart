import 'package:bloc/bloc.dart';

class IconCubit extends Cubit<bool> {
  IconCubit({required state}) : super(state);

  void assignState(bool state) {
    emit(state);
  }

  void toggleState() {
    emit(!state);
  }
}
