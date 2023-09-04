import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/ingredients/category/category_bloc.dart';
import 'package:recipe_hub/services/bloc/ingredients/category/category_event.dart';
import 'package:recipe_hub/services/bloc/ingredients/category/category_state.dart';
import 'package:recipe_hub/services/crud/ingredients_service.dart';
import 'package:recipe_hub/services/cubit/bloc_cubit.dart';
import 'package:recipe_hub/util/util.dart';
import 'package:recipe_hub/view/pages/ingredients/components/search_view.dart';

class IngredientsPage extends StatelessWidget {
  const IngredientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Search for ingredients',
              labelText: 'Ingredients',
              filled: true,
            ),
            onTap: () {
              final searchBloc = context.read<BlocCubit>().searchBloc;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SearchView(searchBloc: searchBloc),
              ));
            },
          ),
        ),
        DefaultTabController(
          length: categories.length,
          child: Expanded(
            child: Material(
              child: Column(
                children: [
                  Material(
                    child: TabBar(
                      isScrollable: true,
                      tabs: categories.map((category) {
                        return Tab(text: category.replaceAll('_', ' / '));
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: categories.map((category) {
                        return BlocProvider(
                          create: (context) => CategoryBloc(),
                          child: BlocBuilder<CategoryBloc, CategoryState>(
                            builder: (context, state) {
                              if (state is CategoryStateUpdate) {
                                if (state.list.isNotEmpty) {
                                  return ListView.builder(
                                    itemCount: state.list.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: getCategoryColor(category),
                                        child: ListTile(
                                          title: Text(state.list[index].name),
                                          trailing: IconButton(
                                            splashRadius: 20,
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              context.read<CategoryBloc>().add(
                                                  CategoryEventRemove(
                                                      ingredient:
                                                          state.list[index]));
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                      child: Text('No ingredients'));
                                }
                              } else {
                                context.read<CategoryBloc>().add(
                                    CategoryEventInitialize(
                                        service: IngredientsService()));
                                context.read<CategoryBloc>().add(
                                    CategoryEventUpdate(category: category));
                                return const Text('');
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
