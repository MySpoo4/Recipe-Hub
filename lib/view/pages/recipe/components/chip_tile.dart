import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_event.dart';
import 'package:recipe_hub/services/cubit/filter_list_cubit.dart';
import 'package:recipe_hub/view/pages/recipe/components/scroll_filter.dart';
import 'package:recipe_hub/view/pages/recipe/components/wrap_filter.dart';

class ChipTile extends StatelessWidget {
  final String name;
  final List<String> stringList;
  const ChipTile({
    super.key,
    required this.name,
    required this.stringList,
  });

  @override
  Widget build(BuildContext context) {
    final filterList = context.read<FilterListCubit>();
    return BlocProvider(
      create: (context) {
        FilterBloc bloc = FilterBloc(
          name: name,
          filters: filterList.recipeBloc.chipFilter[name] ?? {},
          recipeBloc: filterList.recipeBloc,
        );
        filterList.filterList.add(bloc);
        filterList.stringList.add(name);
        return bloc;
      },
      child: Builder(builder: (context) {
        return ExpansionTile(
          textColor: Colors.black,
          title: Text(name),
          children: [
            stringList.length < 10
                ? ScrollFilter(filterList: stringList)
                : WrapFilter(filterList: stringList),
          ],
          onExpansionChanged: (isExpanded) {
            if (!isExpanded) {
              context.read<FilterBloc>().add(const FilterEventResetChips());
            }
          },
        );
      }),
    );
  }
}
