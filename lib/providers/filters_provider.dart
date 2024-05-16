// 1. We import flutter_riverpod.dart
// 2. We go to our filters_screen file and copy over the 'enum Filter'
// 3. Create FilterNotifier class that extends StateNotifier<List<Filter>> and add the toggleFilter method
// 4. We export the FilterNotifier class as a provider

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
      : super({
          // Initializes the state of the filters with all of them set to false
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  // Method to toggle the filter status
  void setFilter(Filter filter, bool value) {
    state = {
      ...state,
      filter: value,
    };
  }
}

// Exporting the FilterNotifier class as a provider
final filterProvider = StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
  (ref) => FilterNotifier(),
);
