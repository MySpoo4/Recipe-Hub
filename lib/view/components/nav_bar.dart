import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/nav/nav_bloc.dart';
import 'package:recipe_hub/services/bloc/nav/nav_event.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        context.read<NavBloc>().add(NavEventIndex(index: index));
      },
      selectedIndex: context.select((NavBloc bloc) => bloc.index),
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.kitchen_outlined),
          selectedIcon: Icon(Icons.kitchen),
          label: 'Ingredients',
        ),
        NavigationDestination(
          icon: Icon(Icons.bookmark_outline),
          selectedIcon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        NavigationDestination(
          icon: Icon(Icons.fastfood_outlined),
          selectedIcon: Icon(Icons.fastfood),
          label: 'Recipes',
        ),
      ],
    );
  }
}
