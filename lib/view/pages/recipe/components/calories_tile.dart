import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/range_slider/range_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/range_slider/range_event.dart';
import 'package:recipe_hub/services/bloc/recipe/range_slider/range_state.dart';
import 'package:recipe_hub/services/cubit/filter_list_cubit.dart';

class CaloriesTile extends StatelessWidget {
  final String name;
  const CaloriesTile({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final filterList = context.read<FilterListCubit>();
    return BlocProvider<RangeBloc>(
      create: (context) {
        RangeBloc bloc = RangeBloc(
          name: name,
          range: filterList.recipeBloc.rangeFilter[name],
          recipeBloc: filterList.recipeBloc,
        );
        filterList.rangeList.add(bloc);
        return bloc;
      },
      child: BlocBuilder<RangeBloc, RangeState>(
        builder: (context, state) {
          RangeValues range = context.select((RangeBloc bloc) => bloc.range);
          return ExpansionTile(
            textColor: Colors.black,
            title: Text(name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${range.start.round()} - ${range.end.round()} kcal',
                    style: textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.expand_more),
              ],
            ),
            children: [
              RangeSlider(
                values: range,
                max: 3000,
                divisions: 30,
                labels: RangeLabels(
                  range.start.round().toString(),
                  range.end.round().toString(),
                ),
                onChanged: (value) {
                  context.read<RangeBloc>().add(RangeEventUpdate(range: value));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
