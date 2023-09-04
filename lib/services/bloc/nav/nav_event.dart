abstract class NavEvent {
  const NavEvent();
}

class NavEventIndex extends NavEvent {
  final int index;
  const NavEventIndex({required this.index});
}
