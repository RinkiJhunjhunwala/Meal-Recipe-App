import "package:flutter/material.dart";

import "package:meal_recipe_project/pages/burger.dart";
import "package:meal_recipe_project/pages/chinese.dart";
import "package:meal_recipe_project/pages/desserts.dart";
import "package:meal_recipe_project/pages/north_indian.dart";
import "package:meal_recipe_project/pages/pizza.dart";

import "package:meal_recipe_project/widgets/main_categories.dart";

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          MainCategories(
            imageAsset: 'assets/NorthIndian.jpeg',
            text: 'North Indian',
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NorthIndian()),
            );
            },
          ),
          MainCategories(
            imageAsset: 'assets/chinese.jpeg',
            text: 'Chinese',
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Chinese()),
            );
            },
          ),
          MainCategories(
            imageAsset: 'assets/burger.jpeg',
            text: 'Burger',
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Burger()),
            );
            },
          ),
          MainCategories(
            imageAsset: 'assets/pizza.jpeg',
            text: 'Pizza',
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Pizza()),
            );
            },
          ),
          MainCategories(
            imageAsset: 'assets/desserts.jpeg',
            text: 'Desserts',
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>const Desserts()),
            );
            },
          ),
        ],
      );
  }
}