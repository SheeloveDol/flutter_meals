import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});

  // To dynamically set the title of the screen we made it optional with a default value of null '?'
  final String? title;
  final List<Meal> meals;

  // To navigate to the meal details screen
  void _selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(meal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // In case there are no meals for the selected category
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => MealItem(
        meal: meals[index],
        onSelectMeal: (meal) {
          _selectMeal(context, meal);
        },
      ),
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Oops!.. no meals found',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please try a different category',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      );
    }

    // If the title is null we return the content without a scaffold which means the content will be displayed without an app bar so that the title is not displayed twice. This is because the content is already displayed in the tab screen which has an app bar.
    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            title!), // We can safely use the '!' here because we know that the title is not null
      ),
      body: content,
    );
  }
}
