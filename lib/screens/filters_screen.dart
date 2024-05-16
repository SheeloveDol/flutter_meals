import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/filters_provider.dart';

// 1. Because we now have a filters_provider.dart file, we can import the Filter enum from there and we now have to convert this class to extend a 'ConsumerStatefulWidget' instead of a 'StatefulWidget'

// setting enum for each of the filters in order to create a map
// enum Filter {
//   glutenFree,
//   lactoseFree,
//   vegetarian,
//   vegan,
// }

class FiltersScreen extends ConsumerStatefulWidget {
  // was StatefulWidget before
  const FiltersScreen({super.key
      // required this.selectedFilters, // we don't need this anymore because we are now using the provider
      });

  // To save the selected filters
  // final Map<Filter, bool> selectedFilters;

  @override
  ConsumerState<FiltersScreen> createState() =>
      _FiltersScreenState(); // was 'State<FiltersScreen>' before
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  // was 'State<FiltersScreen>' before

  var _glutenFreeFilter = false; //
  var _lactoseFreeFilter =
      false; // We are still using the local state to manage the filters so that we can update the UI when the user interacts with the switches
  var _vegetarianFilter = false; //
  var _veganFilter = false; //

  // Because the filters are set in the constructor, they are set in the initState method and we can't use the constructor to set the filters. We use the initState method to set the filters in the state object... <-- This is not necessary anymore because we are now using the provider

  // Instead we are now going to 'read' the initial filters from the provider
  @override
  void initState() {
    super.initState();
    final activeFilters =
        ref.read(filtersProvider); // <-- read the filters from the provider
    _glutenFreeFilter = activeFilters[Filter.glutenFree]!;
    _lactoseFreeFilter = activeFilters[Filter.lactoseFree]!;
    _vegetarianFilter = activeFilters[Filter.vegetarian]!;
    _veganFilter = activeFilters[Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filters'),
        ),
        body: PopScope(
          // PopScope allows for custom back navigation and returns data when leaving the screen. In this case, returning the filters data

          // Now using Riverpod, we will get access to the `setFilter` method from the provider to update the filters in the provider
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) return;
            ref.read(filtersProvider.notifier).setFilters({
              Filter.glutenFree: _glutenFreeFilter,
              Filter.lactoseFree: _lactoseFreeFilter,
              Filter.vegetarian: _vegetarianFilter,
              Filter.vegan: _veganFilter,
            });
            Navigator.of(context).pop();
          },
          child: Column(
            children: [
              SwitchListTile(
                value: _glutenFreeFilter,
                onChanged: (isChecked) {
                  setState(() {
                    _glutenFreeFilter = isChecked;
                  });
                },
                title: Text(
                  'Gluten-free',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                subtitle: Text(
                  'Gluten-free meals only',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                activeColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: const EdgeInsets.only(left: 34, right: 22),
              ),
              SwitchListTile(
                value: _veganFilter,
                onChanged: (isChecked) {
                  setState(() {
                    _veganFilter = isChecked;
                  });
                },
                title: Text(
                  'Vegan',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                subtitle: Text(
                  'Vegan meals only',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                activeColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: const EdgeInsets.only(left: 34, right: 22),
              ),
              SwitchListTile(
                value: _lactoseFreeFilter,
                onChanged: (isChecked) {
                  setState(() {
                    _lactoseFreeFilter = isChecked;
                  });
                },
                title: Text(
                  'Lactose-free',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                subtitle: Text(
                  'Lactose-free meals only',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                activeColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: const EdgeInsets.only(left: 34, right: 22),
              ),
              SwitchListTile(
                value: _vegetarianFilter,
                onChanged: (isChecked) {
                  setState(() {
                    _vegetarianFilter = isChecked;
                  });
                },
                title: Text(
                  'Vegetarian',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                subtitle: Text(
                  'Vegetarian meals only',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                activeColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: const EdgeInsets.only(left: 34, right: 22),
              ),
            ],
          ),
        ));
  }
}
