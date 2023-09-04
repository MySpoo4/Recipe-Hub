import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/indicators/swipe_action.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_event.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_state.dart';
import 'package:recipe_hub/services/cubit/scroll_controller_cubit.dart';
import 'package:recipe_hub/view/pages/recipe/components/recipe_card.dart';

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  void _fetch({required BuildContext context}) {
    context.read<RecipeBloc>().add(const RecipeEventLoadMore());
  }

  @override
  Widget build(BuildContext context) {
    context.read<RecipeBloc>().add(const RecipeEventInit());
    return Expanded(
      child: FetchMoreIndicator(
        onAction: () => _fetch(context: context),
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            final recipeList =
                context.select((RecipeBloc bloc) => bloc.recipeList);
            if (recipeList.isNotEmpty) {
              return BlocProvider<ScrollConCubit>(
                create: (context) =>
                    ScrollConCubit(scrollController: ScrollController()),
                child: BlocListener<RecipeBloc, RecipeState>(
                  listener: (context, state) {
                    if (state is RecipeStateList) {
                      context.read<ScrollConCubit>().resetPos();
                    }
                  },
                  child: BlocBuilder<ScrollConCubit, ScrollController>(
                    builder: (context, state) {
                      return ListView.builder(
                        controller: state,
                        itemCount: recipeList.length,
                        itemBuilder: (context, index) {
                          final info = recipeList[index];
                          return RecipeCard(info: info);
                        },
                      );
                    },
                  ),
                ),
              );
            } else if (state is RecipeStateNoneFound) {
              return const Center(child: Text('None found'));
            } else {
              return const Center(child: Text('Try searching something'));
            }
          },
        ),
      ),
    );
  }
}
