import 'package:flutter/material.dart';
//import 'package:meal_recipe_project/pages/burger.dart';
import 'favorites_page.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final List<Widget> children = [
    const Homepage(),
    FavoritesPage(),
  ];
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Meal Recipe App", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold , fontSize: 24),)),
        backgroundColor: Colors.orange,
        ),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items:const [
          BottomNavigationBarItem(
            icon:  Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.favorite),
            label: 'Favorites',
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  
}

