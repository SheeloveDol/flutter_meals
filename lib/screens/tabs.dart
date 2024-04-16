import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  // To add and remove meals from the favorites list
  final List<Meal> _favoriteMeals = [];

  void _toggleFavorite(Meal meal) {
    final mealAlreadyFavorited = _favoriteMeals.contains(meal);

    if (mealAlreadyFavorited) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoSnackbar("Meal removed from favorites...");
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoSnackbar("Meal added to favorites...");
    }
  }

  // Showing a snackbar when a meal is favorited or removed from favorites
  void _showInfoSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // To dynamically set the page index
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // To select between meals screen and filters screen from side drawer
  void _setScreen(String identifier) {
    if (identifier == 'filters') {
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // To dynamically set the displayed page we must do this inside of the build method
    // This is because the build method is called whenever the state changes
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleFavorite,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleFavorite,
      ); // title is now optional so we don't need to pass it here
      activePageTitle = 'Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSetScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex, // To set the active tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories...',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
