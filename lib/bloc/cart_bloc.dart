import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/database_helper.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  CartBloc() : super(CartState()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemInCart>(_onUpdateItemInCart);
    on<ClearCart>(_onClearCart);
    add(LoadCartItems());
  }

  Future<void> _onLoadCartItems(
      LoadCartItems event, Emitter<CartState> emit) async {
    List<CartItem> items = await _databaseHelper.getCartItems();
    emit(CartState(items: items));
  }

  Future<void> _onAddItemToCart(
      AddItemToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    final updatedItems = List<CartItem>.from(currentState.items);
    final existingItemIndex =
        updatedItems.indexWhere((item) => item.product.id == event.product.id);
    if (existingItemIndex >= 0) {
      final existingItem = updatedItems[existingItemIndex];
      final newQuantity = existingItem.quantity + event.quantity;
      final updatedItem = CartItem(
        product: existingItem.product,
        quantity: newQuantity > 999 ? 999 : newQuantity,
      );
      updatedItems[existingItemIndex] = updatedItem;
      await _databaseHelper.updateCartItem(updatedItem);
    } else {
      final newItem = CartItem(
        product: event.product,
        quantity: event.quantity,
      );
      updatedItems.add(newItem);
      await _databaseHelper.insertCartItem(newItem);
    }
    emit(CartState(items: updatedItems));
  }

  Future<void> _onUpdateItemInCart(
      UpdateItemInCart event, Emitter<CartState> emit) async {
    final currentState = state;
    final updatedItems = List<CartItem>.from(currentState.items);

    final existingItemIndex =
        updatedItems.indexWhere((item) => item.product.id == event.product.id);

    if (existingItemIndex >= 0) {
      final updatedItem = CartItem(
        product: event.product,
        quantity: event.quantity,
      );
      updatedItems[existingItemIndex] = updatedItem;
      await _databaseHelper.updateCartItem(updatedItem);
    }
    emit(CartState(items: updatedItems));
  }

  Future<void> _onRemoveItemFromCart(
      RemoveItemFromCart event, Emitter<CartState> emit) async {
    final updatedItems = List<CartItem>.from(state.items);
    final index =
        updatedItems.indexWhere((item) => item.product.id == event.product.id);
    if (index >= 0) {
      final cartItemId = updatedItems[index].product.id;
      updatedItems.removeAt(index);
      await _databaseHelper.deleteCartItem(cartItemId);
    }
    emit(CartState(items: updatedItems));
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    await _databaseHelper.clearCart();
    emit(CartState(items: []));
  }
}
