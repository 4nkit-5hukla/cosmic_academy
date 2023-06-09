class Product {
  final int id;
  String title;
  double price;
  String description;
  String image;
  bool favorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.favorite,
  });
}
