import 'package:flutter/material.dart';

abstract class RangeState {
  const RangeState();
}

class RangeStateUpdate extends RangeState {
  final RangeValues range;
  const RangeStateUpdate({required this.range});
}

class RangeStateDefault extends RangeState {
  const RangeStateDefault();
}
