import 'package:flutter/material.dart';

abstract class RangeEvent {
  const RangeEvent();
}

class RangeEventUpdate extends RangeEvent {
  final RangeValues range;
  const RangeEventUpdate({required this.range});
}

class RangeEventResetRange extends RangeEvent {
  const RangeEventResetRange();
}
