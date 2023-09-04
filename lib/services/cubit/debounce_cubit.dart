import 'dart:async';

import 'package:bloc/bloc.dart';

class DebounceCubit extends Cubit<Timer?> {
  DebounceCubit() : super(null);

  bool get isActive => state?.isActive ?? false;
  void cancel() {
    state?.cancel();
  }

  void assignTimer(Timer timer) {
    emit(timer);
  }
}
