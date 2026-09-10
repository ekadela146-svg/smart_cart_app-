class Product {
  final int? id;
  final String name;
  final double price;
  final String image;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.image,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }
}