class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final bool isHot;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isHot = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'isHot': isHot,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      isHot: map['isHot'],
    );
  }
}
