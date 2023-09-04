import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/chip/chip_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/chip/chip_event.dart';
import 'package:recipe_hub/services/bloc/recipe/chip/chip_state.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/filter/filter_event.dart';

class WrapFilter extends StatefulWidget {
  final List<String> filterList;
  const WrapFilter({super.key, required this.filterList});

  @override
  State<WrapFilter> createState() => _WrapFilterState();
}

class _WrapFilterState extends State<WrapFilter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: Wrap(
        spacing: 6,
        runSpacing: 0,
        children: widget.filterList.map((String title) {
          return BlocProvider<ChipBloc>(
            create: (context) => ChipBloc(),
            child: Builder(builder: (context) {
              final filters = context.select((FilterBloc bloc) => bloc.filters);
              final ChipBloc chip = BlocProvider.of<ChipBloc>(context);
              if (filters.contains(title)) {
                context
                    .read<FilterBloc>()
                    .add(FilterEventAdd(value: title, chip: chip));
              }
              return BlocBuilder<ChipBloc, ChipState>(
                builder: (context, state) {
                  return FilterChip(
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                        color: filters.contains(title)
                            ? Colors.white
                            : Colors.black),
                    label: Text(title),
                    selected: filters.contains(title),
                    onSelected: (bool selected) {
                      final ChipBloc chip = BlocProvider.of<ChipBloc>(context);
                      if (selected) {
                        context
                            .read<FilterBloc>()
                            .add(FilterEventAdd(value: title, chip: chip));
                        context
                            .read<ChipBloc>()
                            .add(const ChipEventUpdate(state: true));
                      } else {
                        context
                            .read<FilterBloc>()
                            .add(FilterEventRemove(value: title, chip: chip));
                        context
                            .read<ChipBloc>()
                            .add(const ChipEventUpdate(state: false));
                      }
                    },
                  );
                },
              );
            }),
          );
        }).toList(),
      ),
    );
  }
}
