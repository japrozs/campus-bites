import 'package:flutter/material.dart';
import '../db/datbase_helper.dart';
import '../models/resturant.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Restaurant> _favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No favorites yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Save spots from the food list!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Scaffold(),
    );
  }
}
