import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/bloc/cart_bloc.dart';
import 'package:shopping_cart/bloc/cart_event.dart';
import 'package:shopping_cart/widgets/product_info.dart';
import '../models/product.dart';

class AddToCartBottomSheet extends StatefulWidget {
  final Product product;

  const AddToCartBottomSheet({
    super.key,
    required this.product,
  });

  @override
  _AddToCartBottomSheetState createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProductInfo(
                product: widget.product,
                quantity: quantity,
                onQuantityChanged: (newQuantity) {
                  setState(() {
                    quantity = newQuantity;
                  });
                },
                onClosePressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<CartBloc>()
                        .add(AddItemToCart(widget.product, quantity));
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Text(
                      'Add to cart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
