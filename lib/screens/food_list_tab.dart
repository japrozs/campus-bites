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

  void _showFilterSheet() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () => _defaultFilter = prefs.getString('filterPreference') ?? 'Cuisine',
    );
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Default: $_defaultFilter',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Cuisine'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _cuisineFilter ?? 'All',
                    items: _cuisines
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setLocal(() => _cuisineFilter = val),
                  ),
                  const Text('Price'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _priceFilter ?? 'All',
                    items: _prices
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) => setLocal(() => _priceFilter = val),
                  ),
                  const Text('Open Now'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _openFilter == null
                        ? 'All'
                        : (_openFilter! ? 'Open' : 'Closed'),
                    items: ['All', 'Open', 'Closed']
                        .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                        .toList(),
                    onChanged: (val) {
                      setLocal(
                        () => _openFilter = val == 'All' ? null : val == 'Open',
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setLocal(() {
                              _cuisineFilter = null;
                              _priceFilter = null;
                              _openFilter = null;
                            });
                            Navigator.pop(ctx);
                            _applyFilters();
                          },
                          child: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _applyFilters();
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool get _hasActiveFilters =>
      (_cuisineFilter != null && _cuisineFilter != 'All') ||
      (_priceFilter != null && _priceFilter != 'All') ||
      _openFilter != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusBites'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search food spots...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
