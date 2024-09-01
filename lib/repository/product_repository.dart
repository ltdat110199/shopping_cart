import 'package:shopping_cart/models/product.dart';

class ProductRepository {
  final List<Product> _products = List.generate(
    55,
    (index) => Product(
      id: index + 1,
      name: 'Product ${index + 1}',
      price: (index + 1) * 100000,
      imageUrl: 'assets/images/product_${(index % 10) - 1 + 1}.jpg',
      isHot: index > 14 && index < 26,
    ),
  );

  List<Product> get products => _products;

  List<Product> getProducts(int start, int count) {
    return products.sublist(start, start + count);
  }
}
