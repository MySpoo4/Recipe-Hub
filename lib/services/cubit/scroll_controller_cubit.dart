import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ScrollConCubit extends Cubit<ScrollController> {
  late final ScrollController scrollController;
  ScrollController get controller => scrollController;

  ScrollConCubit({required this.scrollController}) : super(scrollController);

  void resetPos() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    emit(scrollController);
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
