class Review {
  final int? id;
  final int restaurantId;
  final int rating;
  final String comment;

  Review({
    this.id,
    required this.restaurantId,
    required this.rating,
    required this.comment,
  });
}
