import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import 'add_review_screen.dart';

class FoodSpotDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const FoodSpotDetailsScreen({super.key, required this.restaurant});

  @override
  State<FoodSpotDetailsScreen> createState() => _FoodSpotDetailsScreenState();
}

class _FoodSpotDetailsScreenState extends State<FoodSpotDetailsScreen> {
  bool _isFavorite = false;
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    _loadReviews();
  }

  Future<void> _checkFavorite() async {
    final fav = await DatabaseHelper.instance.isFavorite(widget.restaurant.id!);
    setState(() => _isFavorite = fav);
  }

  Future<void> _loadReviews() async {
    final reviews = await DatabaseHelper.instance.getReviews(
      widget.restaurant.id!,
    );
    setState(() => _reviews = reviews);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await DatabaseHelper.instance.removeFavorite(widget.restaurant.id!);
    } else {
      await DatabaseHelper.instance.addFavorite(widget.restaurant.id!);
    }
    setState(() => _isFavorite = !_isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites!' : 'Removed from favorites.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Spot Details'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.restaurant_menu, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Cuisine: ${r.cuisine}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Price: ${r.price}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Hours: ${r.hours}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFavorite
                          ? Colors.red[400]
                          : Colors.green[700],
                    ),
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    label: Text(
                      _isFavorite ? 'Remove Favorite' : 'Save to Favorites',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddReviewScreen(restaurantId: r.id!),
                        ),
                      );
                      _loadReviews();
                    },
                    icon: const Icon(Icons.rate_review, color: Colors.white),
                    label: const Text(
                      'Add Review',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: _reviews.isEmpty
                  ? const Center(
                      child: Text(
                        'No reviews yet. Be the first!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _reviews.length,
                      itemBuilder: (ctx, i) {
                        final rev = _reviews[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Text(
                              '${rev.rating}',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(rev.comment),
                          subtitle: Row(
                            children: List.generate(
                              5,
                              (j) => Icon(
                                j < rev.rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
