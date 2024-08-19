

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meal_recipe_project/favorites_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_recipe_project/favorites_page.dart';

class NorthIndian extends StatefulWidget {
  const NorthIndian({super.key});

  @override
  _NorthIndianState createState() => _NorthIndianState();
}

class _NorthIndianState extends State<NorthIndian> {
  List<MenuItem> items = [];
  List<MenuItem> favoriteMeals = [];
  String selectedCategory = 'Veg';

  @override
  void initState() {
    super.initState();
    loadMeals();
    loadFavorites();
  }

  Future<void> loadMeals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? meals = prefs.getStringList('NorthIndian_meals');
    if (meals != null) {
      setState(() {
        items = meals.map((item) => MenuItem.fromJson(item)).toList();
      });
    } else {
      items = [
    MenuItem(
      name: 'Daal Makhani', 
      isVeg: true, 
      isNonVeg: false, 
      isGlutenFree: false, 
      isLactoseFree: false,
      ingredients: ['Daal', 'Tomato', 'Vegetables'],
      steps: ['Soak daal', 'Put tomato', 'Put Vegetables'],
      ),
    MenuItem(
      name: 'Chicken Biryani', 
      isVeg: false, 
      isNonVeg: true, 
      isGlutenFree: false, 
      isLactoseFree: false,
      ingredients: ['Rice', 'Chicken', 'Vegetables'],
      steps: ['Soak rice', 'Cook chicken', 'Chop vegetables'],
      ),
    MenuItem(
      name: 'Gluten-Free Paratha', 
      isVeg: false, 
      isNonVeg: false, 
      isGlutenFree: true, 
      isLactoseFree: false,
      ingredients: ['Gluten free Maida', 'Potato', 'Spices'],
      steps: ['Bake dough', 'Put potato', 'Put Spices'],
      ),
    MenuItem(
      name: 'Lactose-Free Paratha', 
      isVeg: false, 
      isNonVeg: false, 
      isGlutenFree: false, 
      isLactoseFree: true,
      ingredients: ['Lactose free Maida', 'Potato', 'Spices'],
      steps: ['Bake dough', 'Put potato', 'Put Spices'],
      ),
    MenuItem(
      name: 'Vegetable Biryani', 
      isVeg: true, 
      isNonVeg: false, 
      isGlutenFree: true, 
      isLactoseFree: true,
      ingredients: ['Rice', 'Spices', 'Vegetables'],
      steps: ['Soak daal', 'Put spices', 'Put Vegetables'],
      ),
  ];
      saveMeals();
    }
  }

  Future<void> saveMeals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> meals = items.map((item) => item.toJson()).toList();
    await prefs.setStringList('NorthIndian_meals', meals);
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

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = favoriteMeals.map((item) => item.toJson()).toList();
    await prefs.setStringList('favorites', favorites);
  }

  void addMeal(MenuItem newItem) {
    setState(() {
      items.add(newItem);
      saveMeals();
    });
  }

  void deleteMeal(MenuItem itemToDelete) {
    setState(() {
      items.remove(itemToDelete);
      saveMeals();
    });
  }

  void onCategoryPressed(String category) {
    setState(() {
      selectedCategory = category;
    });
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

  List<MenuItem> get filteredItems {
    switch (selectedCategory) {
      case 'Veg':
        return items.where((item) => item.isVeg).toList();
      case 'Non-Veg':
        return items.where((item) => item.isNonVeg).toList();
      case 'Gluten-Free':
        return items.where((item) => item.isGlutenFree).toList();
      case 'Lactose-Free':
        return items.where((item) => item.isLactoseFree).toList();
      default:
        return items;
    }
  }

  Future<void> showAddMealDialog(BuildContext context) async {
    String name = '';
    bool isVeg = false;
    bool isNonVeg = false;
    bool isGlutenFree = false;
    bool isLactoseFree = false;
    List<String> ingredients = [];
    List<String> steps = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState){
          return AlertDialog(
          title: const Text('Add New Meal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CheckboxListTile(
                  title: const Text('Veg'),
                  value: isVeg,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isVeg = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Non-Veg'),
                  value: isNonVeg,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isNonVeg = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Gluten-Free'),
                  value: isGlutenFree,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isGlutenFree = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Lactose-Free'),
                  value: isLactoseFree,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isLactoseFree = value ?? false;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Ingredients (comma separated)'),
                  onChanged: (value) {
                    ingredients = value.split(',').map((e) => e.trim()).toList();
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Steps (comma separated)'),
                  onChanged: (value) {
                    steps = value.split(',').map((e) => e.trim()).toList();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                MenuItem newMeal = MenuItem(
                  name: name,
                  isVeg: isVeg,
                  isNonVeg: isNonVeg,
                  isGlutenFree: isGlutenFree,
                  isLactoseFree: isLactoseFree,
                  ingredients: ingredients,
                  steps: steps,
                );
                addMeal(newMeal);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        },);
      },
    );
  }

  Future<void> toggleFavorite(MenuItem meal) async {
    setState(() {
      if (favoriteMeals.contains(meal)) {
        favoriteMeals.remove(meal);
      } else {
        favoriteMeals.add(meal);
      }
      saveFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('North Indian', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'North Indian',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 40.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryButton(
                    icon: Icons.eco,
                    label: 'Veg',
                    onPressed: onCategoryPressed,
                    isSelected: selectedCategory == 'Veg',
                  ),
                  CategoryButton(
                    icon: Icons.restaurant,
                    label: 'Non-Veg',
                    onPressed: onCategoryPressed,
                    isSelected: selectedCategory == 'Non-Veg',
                  ),
                  CategoryButton(
                    icon: Icons.no_meals,
                    label: 'Gluten-Free',
                    onPressed: onCategoryPressed,
                    isSelected: selectedCategory == 'Gluten-Free',
                  ),
                  CategoryButton(
                    icon: Icons.no_drinks,
                    label: 'Lactose-Free',
                    onPressed: onCategoryPressed,
                    isSelected: selectedCategory == 'Lactose-Free',
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isFavorited = favoriteMeals.contains(item);
                  return ContainerCard(
                    name: item.name,
                    isVeg: item.isVeg,
                    isNonVeg: item.isNonVeg,
                    isGlutenFree: item.isGlutenFree,
                    isLactoseFree: item.isLactoseFree,
                    onHeartPressed: () {
                      toggleFavorite(item);
                    },
                    onDeletePressed: () {
                      deleteMeal(item);
                    },
                    onRecipePressed: () {
                      _showRecipeDialog(context, item);
                    },
                    isFavorite: isFavorited,
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: AddMealButton(
                onPressed: () {
                  showAddMealDialog(context);
                },
              ),
            ),
          ],
        ),
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

class AddMealButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddMealButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.black),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          'Add Meal',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function(String) onPressed;
  final bool isSelected;

  const CategoryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}