import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class TextConCubit extends Cubit<TextEditingController> {
  late final TextEditingController textController;
  TextEditingController get controller => textController;

  TextConCubit({required this.textController}) : super(textController);
}
