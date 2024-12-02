class Product {
  final String image;
  final String title;
  final String category;
  final double price;

  Product({
    required this.image,
    required this.title,
    required this.category,
    required this.price,
  });

  // crée un objet à partir des données JSON de l'API
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'],
      title: json['title'],
      category: json['category'],
      price: json['price'].toDouble(),
    );
  }
}
