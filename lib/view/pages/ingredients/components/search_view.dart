import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/ingredients/search/search_bloc.dart';
import 'package:recipe_hub/services/bloc/ingredients/search/search_event.dart';
import 'package:recipe_hub/services/bloc/ingredients/search/search_state.dart';
import 'package:recipe_hub/services/crud/ingredients_service.dart';
import 'package:recipe_hub/services/cubit/debounce_cubit.dart';
import 'package:recipe_hub/services/cubit/text_controller.dart';
import 'package:recipe_hub/view/components/clear_button.dart';

class SearchView extends StatelessWidget {
  final SearchBloc searchBloc;
  const SearchView({
    super.key,
    required this.searchBloc,
  });

  void _onSearchChanged(
    DebounceCubit cubit,
    SearchBloc bloc,
  ) {
    if (cubit.isActive) cubit.cancel();
    cubit.assignTimer(Timer(
      const Duration(milliseconds: 300),
      () {
        bloc.add(const SearchEventQuery());
      },
    ));
  }

  Widget _getHistoryList(
    List<String> history,
    SearchBloc bloc,
  ) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: history.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.history),
            title: Text(history[index]),
            trailing: IconButton(
              onPressed: () {
                bloc.changeText(history[index]);
                bloc.add(const SearchEventUpdate());
              },
              icon: const Icon(Icons.call_missed),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = searchBloc.controller;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: BlocProvider.value(
        value: searchBloc,
        child: Builder(builder: (context) {
          return Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<TextConCubit>(
                          create: (context) =>
                              TextConCubit(textController: controller)),
                      BlocProvider<DebounceCubit>(
                          create: (context) => DebounceCubit()),
                    ],
                    child: Builder(builder: (context) {
                      final controller =
                          context.read<TextConCubit>().controller;
                      return TextField(
                        autofocus: true,
                        controller: controller,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          _onSearchChanged(
                            context.read<DebounceCubit>(),
                            searchBloc,
                          );
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search Ingredients',
                          prefixIcon: IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          suffixIcon: ClearButton(
                            controller: controller,
                            function: () {
                              searchBloc.add(const SearchEventUpdate());
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 0.7,
              ),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    final list = searchBloc.list;
                    final history = searchBloc.searchHistory;
                    final query = searchBloc.query;
                    if (query.isEmpty) {
                      if (history.isNotEmpty) {
                        return _getHistoryList(history, searchBloc);
                      } else {
                        return const Center(child: Text('No search history.'));
                      }
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(list[index].name),
                              trailing: IconButton(
                                onPressed: () {
                                  searchBloc.addSearch(list[index].name);
                                  IngredientsService()
                                      .createIngredient(item: list[index])
                                      .catchError((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Ingredient Already Added'),
                                      ),
                                    );
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
