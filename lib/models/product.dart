class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
  });

  // This function converts the API JSON data into a Flutter Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      // The API sometimes returns images as a string like "[url]", we clean it here
      images: List<String>.from(json['images'].map((x) => 
        x.toString().replaceAll('[', '').replaceAll(']', '').replaceAll('"', ''))),
    );
  }
}