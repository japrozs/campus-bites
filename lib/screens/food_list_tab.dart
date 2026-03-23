import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodListTab extends StatefulWidget {
  const FoodListTab({super.key});

  @override
  State<FoodListTab> createState() => _FoodListTabState();
}

class _FoodListTabState extends State<FoodListTab> {
  final _searchController = TextEditingController();
  String? _cuisineFilter;
  String? _priceFilter;
  bool? _openFilter;
  String _defaultFilter = 'Cuisine';

  final List<String> _cuisines = [
    'All',
    'American',
    'Chinese',
    'Mexican',
    'Italian',
    'Sandwiches',
    'Coffee',
  ];
  final List<String> _prices = ['All', '\$', '\$\$'];

  @override
  void initState() {
    super.initState();
    _loadPreferenceAndRestaurants();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferenceAndRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    final data = await DatabaseHelper.instance.getRestaurants();
    setState(() {
      _defaultFilter = prefs.getString('filterPreference') ?? 'Cuisine';
      _all = data;
      _filtered = data;
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _all.where((r) {
        final matchesSearch =
            query.isEmpty ||
            r.name.toLowerCase().contains(query) ||
            r.cuisine.toLowerCase().contains(query);
        final matchesCuisine =
            _cuisineFilter == null ||
            _cuisineFilter == 'All' ||
            r.cuisine == _cuisineFilter;
        final matchesPrice =
            _priceFilter == null ||
            _priceFilter == 'All' ||
            r.price == _priceFilter;
        final matchesOpen = _openFilter == null || r.isOpen == _openFilter;
        return matchesSearch && matchesCuisine && matchesPrice && matchesOpen;
      }).toList();
    });
  }
}
