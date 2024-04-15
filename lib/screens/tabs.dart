import 'package:flutter/material.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  // To dynamically set the page index
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // To dynamically set the displayed page we must do this inside of the build method
    // This is because the build method is called whenever the state changes
    Widget activePage = const CategoriesScreen();
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = const MealsScreen(
          meals: []); // title is now optional so we don't need to pass it here
      activePageTitle = 'Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
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
