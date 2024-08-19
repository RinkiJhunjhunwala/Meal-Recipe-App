
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_recipe_project/pages/burger.dart';
import 'package:meal_recipe_project/pages/chinese.dart';


class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<MenuItem> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites != null) {
      setState(() {
        favoriteMeals = favorites.map((item) => MenuItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> removeFavorite(MenuItem meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites != null) {
      favorites.remove(meal.toJson());
      await prefs.setStringList('favorites', favorites);
      loadFavorites();
    }
  }

  void _showRecipeDialog(BuildContext context, MenuItem item) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(item.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingredients:',
                
              ),
              ...item.ingredients.map((ingredient) => Text('• $ingredient')),
              SizedBox(height: 16.0),
              Text(
                'Steps:',
                
              ),
              ...item.steps.map((step) => Text('• $step')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Meals'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          final meal = favoriteMeals[index];
          return ContainerCard(
            name: meal.name,
            isVeg: meal.isVeg,
            isNonVeg: meal.isNonVeg,
            isGlutenFree: meal.isGlutenFree,
            isLactoseFree: meal.isLactoseFree,
            onHeartPressed: () {
              removeFavorite(meal);
            },
            onDeletePressed: () {},
            onRecipePressed: () {
                      _showRecipeDialog(context, meal);
                    },
            isFavorite: true,
          );
        },
      ),
    );
  }
}

class ContainerCard extends StatelessWidget {
  final String name;
  final bool isVeg;
  final bool isNonVeg;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final VoidCallback onHeartPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onRecipePressed;
  final bool isFavorite;

  const ContainerCard({
    required this.name,
    required this.isVeg,
    required this.isNonVeg,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.onHeartPressed,
    required this.onDeletePressed,
    required this.onRecipePressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            Icons.favorite,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onHeartPressed,
        ),
        title: Text(name),
        subtitle: Row(
          children: [
            if (isVeg) Icon(Icons.eco, color: Colors.green),
            if (isNonVeg) Icon(Icons.restaurant, color: Colors.red),
            if (isGlutenFree) Icon(Icons.no_meals, color: Colors.blue),
            if (isLactoseFree) Icon(Icons.no_drinks, color: Colors.orange),
            Text("Click for recipe"),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.black),
          onPressed: onDeletePressed,
        ),
        onTap: onRecipePressed,
      ),
    );
  }
}

class MenuItem {
  final String name;
  final bool isVeg;
  final bool isNonVeg;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final List<String> ingredients;
  final List<String> steps;

  MenuItem({
    required this.name,
    required this.isVeg,
    required this.isNonVeg,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.ingredients,
    required this.steps,
  });
  factory MenuItem.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return MenuItem(
      name: json['name'],
      isVeg: json['isVeg'],
      isNonVeg: json['isNonVeg'],
      isGlutenFree: json['isGlutenFree'],
      isLactoseFree: json['isLactoseFree'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }

  String toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'isVeg': isVeg,
      'isNonVeg': isNonVeg,
      'isGlutenFree': isGlutenFree,
      'isLactoseFree': isLactoseFree,
      'ingredients': ingredients,
      'steps': steps,
    };
    return jsonEncode(json);
  }
}

