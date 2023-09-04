import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  final TextEditingController controller;
  final Function? function;
  const ClearButton({
    super.key,
    required this.controller,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        controller.clear();
        if (function != null) {
          function!();
        }
      },
      icon: const Icon(Icons.clear),
    );
  }
}
