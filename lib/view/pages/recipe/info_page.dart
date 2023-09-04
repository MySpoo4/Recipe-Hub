import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_bloc.dart';
import 'package:recipe_hub/services/bloc/saved/saved_event.dart';
import 'package:recipe_hub/services/cubit/icon_cubit.dart';
import 'package:recipe_hub/util/util.dart';
import 'package:recipe_hub/view/pages/recipe/web_page.dart';

class InfoPage extends StatelessWidget {
  final RecipeInfo recipeInfo;
  final SavedBloc savedBloc;
  const InfoPage({
    super.key,
    required this.recipeInfo,
    required this.savedBloc,
  });

  Widget categoryTiles() {
    if (recipeInfo.dietLabels.isNotEmpty) {
      return SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recipeInfo.dietLabels.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 5,
              ),
              child: Chip(label: Text(recipeInfo.dietLabels[index])),
            );
          },
        ),
      );
    }
    return Container();
  }

  void showSheet(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0)).then(
      (value) {
        Scaffold.of(context).showBottomSheet<void>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 340,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('BottomSheet'),
                    ElevatedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 0, 0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                mini: true,
                heroTag: null,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 24, 0),
              child: BlocProvider<IconCubit>(
                create: (context) {
                  return IconCubit(state: savedBloc.contains(recipeInfo));
                },
                child: BlocBuilder<IconCubit, bool>(
                  builder: (context, state) {
                    return FloatingActionButton(
                      onPressed: () {
                        context.read<IconCubit>().toggleState();
                        if (!state) {
                          savedBloc.add(SavedEventAdd(recipeInfo: recipeInfo));
                        } else {
                          savedBloc.add(SavedEventRemove(uri: recipeInfo.uri));
                        }
                      },
                      mini: true,
                      heroTag: null,
                      backgroundColor: Colors.white,
                      child: state
                          ? Icon(
                              Icons.bookmark,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : Icon(
                              Icons.bookmark_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WebPage(url: recipeInfo.source),
                    ),
                  );
                },
                label: const Text('Read Recipe'),
                icon: const Icon(Icons.restaurant_menu),
              ),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              SafeArea(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: recipeInfo.imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 340,
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height - 340,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          recipeInfo.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${(recipeInfo.caloriesPerServing / recipeInfo.servings).round()} cal per serving',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      recipeInfo.servings == 1
                                          ? '1 serving'
                                          : '${recipeInfo.servings} servings',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                categoryTiles(),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Ingredients (${recipeInfo.ingredients.length})',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: recipeInfo.ingredients
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final int index = entry.key;
                                    return Card(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              clipBehavior: Clip.hardEdge,
                                              child: CachedNetworkImage(
                                                imageUrl: recipeInfo
                                                    .ingredientImage[index],
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
                                                    height: 75,
                                                    width: 75,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                progressIndicatorBuilder:
                                                    (context, url, progress) {
                                                  return const CircularProgressIndicator();
                                                },
                                                errorWidget:
                                                    (context, url, error) {
                                                  return const SizedBox(
                                                    height: 75,
                                                    width: 75,
                                                    child: Center(
                                                      child: Icon(Icons.error),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 220,
                                            child: Text(
                                              entry.value,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 60),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
