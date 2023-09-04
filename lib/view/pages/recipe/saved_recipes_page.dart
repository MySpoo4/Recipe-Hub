import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_state.dart';
import 'package:recipe_hub/services/cubit/bloc_cubit.dart';
import 'package:recipe_hub/view/pages/recipe/components/recipe_card.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final savedBloc = context.read<BlocCubit>().savedBloc;
    return BlocProvider.value(
      value: savedBloc,
      child: BlocBuilder<SavedBloc, SavedState>(
        builder: (context, state) {
          final list = savedBloc.list;
          if (list.isNotEmpty) {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return RecipeCard(info: list[index]);
              },
            );
          } else {
            return const Center(child: Text('No saved recipes'));
          }
        },
      ),
    );
  }
}
