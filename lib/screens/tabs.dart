import 'package:flutter/material.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters_screen.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart'; // 1. We import the filters_provider.dart file

// setting initial default filters
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabScreen extends ConsumerStatefulWidget {
  // ConsumerStatefulWidget is used with Riverpod
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() =>
      _TabScreenState(); // ConsumerState is used with Riverpod
}

class _TabScreenState extends ConsumerState<TabScreen> {

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
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(
              // selectedFilters: activeFilters,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(
        filteredMealsProvider); // 2. We use the filteredMealsProvider to get the filtered meals data

    // Check if availableMeals is null and display a loading indicator or an empty message
    if (availableMeals == null) {
      return const Center(
        child: CircularProgressIndicator(), // Loading indicator
      );
    }

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals:
            favoriteMeals, // we use the favoriteMealsProvider to get the favorite meals data
        // onToggleFavorite: _toggleFavorite,
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
