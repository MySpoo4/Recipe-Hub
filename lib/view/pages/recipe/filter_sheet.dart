import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/cubit/filter_list_cubit.dart';
import 'package:recipe_hub/view/pages/recipe/components/chip_tile.dart';
import 'package:recipe_hub/view/pages/recipe/filter_list/filter_items.dart';

class Filter extends StatelessWidget {
  final RecipeBloc recipeBloc;
  const Filter({
    super.key,
    required this.recipeBloc,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return BlocProvider<FilterListCubit>(
      create: (context) => FilterListCubit(recipeBloc: recipeBloc),
      child: Builder(builder: (context) {
        final filterList = context.read<FilterListCubit>();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashRadius: 20,
                  icon: const Icon(Icons.arrow_back),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text('Filter', style: textTheme.titleMedium),
                ),
                IconButton(
                  onPressed: () {
                    filterList.reset();
                  },
                  splashRadius: 20,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (!data[index].special) {
                    return ChipTile(
                      name: data[index].headerValue,
                      stringList: data[index].expandedValue ?? [],
                    );
                  } else {
                    return data[index].widget;
                  }
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
