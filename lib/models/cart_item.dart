import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'totalPrice': totalPrice
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, Product product) {
    return CartItem(
      product: product,
      quantity: map['quantity'],
    );
  }
}
