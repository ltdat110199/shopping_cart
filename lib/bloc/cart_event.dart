import '../models/product.dart';

abstract class CartEvent {}

class AddItemToCart extends CartEvent {
  final Product product;
  final int quantity;

  AddItemToCart(this.product, this.quantity);
}

class UpdateItemInCart extends CartEvent {
  final Product product;
  final int quantity;

  UpdateItemInCart(this.product, this.quantity);
}

class RemoveItemFromCart extends CartEvent {
  final Product product;

  RemoveItemFromCart(this.product);
}

class ClearCart extends CartEvent {}

class LoadCartItems extends CartEvent {}
