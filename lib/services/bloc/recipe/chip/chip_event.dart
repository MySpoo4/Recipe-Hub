abstract class ChipEvent {
  const ChipEvent();
}

class ChipEventUpdate extends ChipEvent {
  final bool state;
  const ChipEventUpdate({required this.state});
}
