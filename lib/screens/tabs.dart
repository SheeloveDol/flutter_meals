import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters_screen.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

// setting initial default filters
const KInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  // To add and remove meals from the favorites list
  final List<Meal> _favoriteMeals = [];

  // To store the selected filters
  Map<Filter, bool> _selectedFilters = KInitialFilters;

// To toggle the favorite status of a meal
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

  // 1. To select between meals screen and filters screen from side drawer
  // 2. To pass the filters data to the meals screen we turn the _setScreen method into an async method
  //    and await the result from the Navigator.push method with the new data from the filters screen
  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // To close the drawer
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(selectedFilters: _selectedFilters,),
        ),
      );

      // If the result is null, we don't want to change the filters. Otherwise, we update the filters
      setState(() {
        _selectedFilters = result ?? KInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // To filter the meals based on the selected filters and then we pass this list to the categories screen to display the meals
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    // To dynamically set the displayed page we must do this inside of the build method
    // This is because the build method is called whenever the state changes
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleFavorite,
      availableMeals: availableMeals,
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
