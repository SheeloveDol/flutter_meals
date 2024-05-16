import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

// final favoritesProvider = Provider() is great for static data, but we need to store a list of favorites which can change
// So we will use a StateNotifierProvider class instead as it is optimized for managing state/data that can change

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier()
      : super(
            []); // Initialize the state with the initial data using the super() constructor method as an initializer `:`

// Now we add our methods to manage the state of our favorite meals list. Keep in mind, we are not allowed to modify the state directly, so we will use the `state` property to access the current state and update it accordingly
  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state
          .where((item) => item.id != meal.id)
          .toList(); // if the meal is in the list, return a new list without it
          return false; // return false to indicate that the meal was removed in order to update the snackbar message
    } else {
      state = [...state, meal]; // if the meal is not in the list, add it
      return true; // return true to indicate that the meal was added in order to update the snackbar message
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  // told StateNotifierProvider which type of StateNotifier we are using and the type of state it manages
  return FavoriteMealsNotifier(); // Create an instance of the FavoriteMealsNotifier class which allows to access the state and methods to manage the state
});
