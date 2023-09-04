import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/api/recipe_api.dart';
import 'package:recipe_hub/services/bloc/ingredients/search/search_bloc.dart';
import 'package:recipe_hub/services/bloc/nav/nav_bloc.dart';
import 'package:recipe_hub/services/bloc/nav/nav_state.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_event.dart';
import 'package:recipe_hub/services/bloc/saved/saved_bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_event.dart';
import 'package:recipe_hub/services/crud/saved_service.dart';
import 'package:recipe_hub/services/crud/search_service.dart';
import 'package:recipe_hub/services/cubit/bloc_cubit.dart';
import 'package:recipe_hub/view/components/nav_bar.dart';
import 'package:recipe_hub/view/pages/recipe/saved_recipes_page.dart';
import 'package:recipe_hub/view/pages/ingredients/ingredients_page.dart';
import 'package:recipe_hub/view/pages/recipe/recipe_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _getPage({required NavState state}) {
    if (state is NavStateUpdate) {
      switch (state.index) {
        case 0:
          return const IngredientsPage();
        case 1:
          return const SavedPage();
        case 2:
          return const RecipePage();
      }
    }
    return Container();
  }

  Widget? _getAppBar({required NavState state}) {
    if (state is NavStateUpdate) {
      switch (state.index) {
        case 0:
          return const Text('Ingredients');
        case 1:
          return const Text('Saved Recipes');
        case 2:
          return const Text('Recipes');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavBloc>(
          create: (context) => NavBloc(),
        ),
        BlocProvider(
          create: (context) => BlocCubit(
            recipeBloc: RecipeBloc(service: RecipeService()),
            searchBloc: SearchBloc(
              service: SearchService(),
              controller: TextEditingController(),
            ),
            savedBloc: SavedBloc(service: SaveService()),
          ),
        )
      ],
      child: Builder(builder: (context) {
        context.read<BlocCubit>().savedBloc.add(const SavedEventInit());
        context.read<BlocCubit>().recipeBloc.add(const RecipeEventAPI());
        return BlocBuilder<NavBloc, NavState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: _getAppBar(state: state),
              ),
              bottomNavigationBar: const NavBar(),
              body: BlocBuilder<NavBloc, NavState>(
                builder: (context, state) {
                  return _getPage(state: state);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
