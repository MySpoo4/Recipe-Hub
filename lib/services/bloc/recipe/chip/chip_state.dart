abstract class ChipState {
  const ChipState();
}

class ChipStateUpdate extends ChipState {
  final bool state;
  const ChipStateUpdate({required this.state});
}

class ChipStateDefault extends ChipState {
  const ChipStateDefault();
}
