import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_bloc.dart';
import 'package:recipe_hub/services/bloc/recipe/recipe_search/recipe_event.dart';
import 'package:recipe_hub/services/cubit/bloc_cubit.dart';
import 'package:recipe_hub/services/cubit/text_controller.dart';
import 'package:recipe_hub/view/components/clear_button.dart';
import 'package:recipe_hub/view/pages/recipe/filter_sheet.dart';
import 'package:recipe_hub/view/pages/recipe/recipe_list.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeBloc = context.read<BlocCubit>().recipeBloc;
    return BlocProvider.value(
      value: context.read<BlocCubit>().recipeBloc,
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocProvider<TextConCubit>(
                        create: (context) => TextConCubit(
                            textController: TextEditingController()),
                        child: Builder(builder: (context) {
                          final controller =
                              context.read<TextConCubit>().controller;
                          return TextField(
                            controller: controller,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: ClearButton(controller: controller),
                              border: const OutlineInputBorder(),
                              hintText: 'Search for recipes',
                              labelText: 'Recipes',
                              filled: true,
                            ),
                            onSubmitted: (String value) {
                              context
                                  .read<RecipeBloc>()
                                  .add(RecipeEventQuery(query: value));
                            },
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton.filledTonal(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            constraints: BoxConstraints.loose(Size(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height * 0.75)),
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return Filter(recipeBloc: recipeBloc);
                            },
                          );
                        },
                        icon: const Icon(Icons.tune),
                      ),
                    ),
                  ],
                ),
              ),
              const RecipeList(),
            ],
          );
        },
      ),
    );
  }
}
