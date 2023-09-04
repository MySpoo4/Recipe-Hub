abstract class NavState {
  const NavState();
}

class NavStateUpdate extends NavState {
  final int index;
  const NavStateUpdate({required this.index});
}
