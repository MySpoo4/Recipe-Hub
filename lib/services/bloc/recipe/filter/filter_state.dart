abstract class FilterState {
  const FilterState();
}

class FilterStateUpdate extends FilterState {
  final int length;
  const FilterStateUpdate({required this.length});
}

class FilterStateDefault extends FilterState {
  const FilterStateDefault();
}
