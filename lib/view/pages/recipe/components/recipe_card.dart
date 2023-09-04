import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_event.dart';
import 'package:recipe_hub/services/cubit/bloc_cubit.dart';
import 'package:recipe_hub/services/cubit/icon_cubit.dart';
import 'package:recipe_hub/util/util.dart';
import 'package:recipe_hub/view/pages/recipe/info_page.dart';

class RecipeCard extends StatelessWidget {
  final RecipeInfo info;
  const RecipeCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(
          displayColor: Theme.of(context).colorScheme.onPrimary,
          bodyColor: Theme.of(context).colorScheme.onPrimaryContainer,
        );
    final savedBloc = context.read<BlocCubit>().savedBloc;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: info.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, progress) {
              return const SizedBox(
                height: 160,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorWidget: (context, url, error) {
              return const SizedBox(
                height: 160,
                child: Center(child: Icon(Icons.error)),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  info.name,
                  style: textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InfoPage(
                              recipeInfo: info,
                              savedBloc: savedBloc,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'More Info',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Builder(builder: (context) {
                      return BlocProvider<IconCubit>(
                        key: UniqueKey(),
                        create: (context) {
                          return IconCubit(
                              state: context
                                  .read<BlocCubit>()
                                  .savedBloc
                                  .contains(info));
                        },
                        child: BlocBuilder<IconCubit, bool>(
                          builder: (context, state) {
                            return IconButton(
                              isSelected: state,
                              onPressed: () {
                                context.read<IconCubit>().toggleState();
                                if (!state) {
                                  savedBloc
                                      .add(SavedEventAdd(recipeInfo: info));
                                } else {
                                  savedBloc
                                      .add(SavedEventRemove(uri: info.uri));
                                }
                              },
                              icon: const Icon(Icons.bookmark_outline),
                              selectedIcon: const Icon(Icons.bookmark),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
