import '../../models/cart_item.dart';

class CartState {
  final List<CartItem> items;

  CartState({this.items = const []});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
