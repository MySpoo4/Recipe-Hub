import 'package:flutter/material.dart';

abstract class SavedState {
  const SavedState();
}

class SavedStateUpdate extends SavedState {
  final Key key = UniqueKey();
  SavedStateUpdate();
}

class SavedStateDefault extends SavedState {
  const SavedStateDefault();
}
