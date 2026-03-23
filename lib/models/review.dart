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

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      restaurantId: map['restaurantId'],
      rating: map['rating'],
      comment: map['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'restaurantId': restaurantId,
      'rating': rating,
      'comment': comment,
    };
  }
}
