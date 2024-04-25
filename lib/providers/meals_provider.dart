import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';

// This provider is similar to context api in react. It is used to provide the meals data to the app
final mealsProvider = Provider((ref) {
  return dummyMeals;
});
