class Restaurant {
  final int? id;
  final String name;
  final String cuisine;
  final String price;
  final String hours;
  final bool isOpen;

  Restaurant({
    this.id,
    required this.name,
    required this.cuisine,
    required this.price,
    required this.hours,
    required this.isOpen,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      cuisine: map['cuisine'],
      price: map['price'],
      hours: map['hours'],
      isOpen: map['isOpen'] == 1,
    );
  }