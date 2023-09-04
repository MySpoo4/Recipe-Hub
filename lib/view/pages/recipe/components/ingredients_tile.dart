import 'package:flutter/material.dart';
import 'package:recipe_hub/services/crud/ingredients_service.dart';
import 'package:recipe_hub/view/pages/recipe/components/chip_tile.dart';

class IngredientsTile extends StatelessWidget {
  final String name;
  const IngredientsTile({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IngredientsService().getAllIngredients().then(
        (value) {
          return value.map((element) => element.name);
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading...'));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ChipTile(
            name: name,
            stringList: snapshot.requireData.toList(),
          );
        }
      },
    );
  }
}
