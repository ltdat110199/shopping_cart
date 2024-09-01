import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping_cart/bloc/cart_bloc.dart';
import 'package:shopping_cart/bloc/cart_event.dart';

import '../dialog/quantily_dialog.dart';
import '../models/product.dart';

class ProductInfo extends StatefulWidget {
  const ProductInfo(
      {super.key,
      required this.product,
      required this.quantity,
      this.onQuantityChanged,
      required this.onClosePressed,
      this.price,
      this.isCartScreen = false});

  final Product product;
  final int quantity;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback onClosePressed;
  final bool isCartScreen;
  final String? price;

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat('#,##0').format(widget.product.price);
    var quantity = widget.quantity;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image.asset(
                  widget.product.imageUrl.toString(),
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.remove, size: 24),
                            onPressed: () {
                              if (quantity > 1) {
                                if (widget.isCartScreen) {
                                  context
                                      .read<CartBloc>()
                                      .add(AddItemToCart(widget.product, -1));
                                } else {
                                  widget.onQuantityChanged!(quantity - 1);
                                }
                              }
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showQuantityDialog(
                              context: context,
                              name: widget.product.name,
                              initialQuantity: quantity,
                              onQuantityChanged: (newQuantity) {
                                setState(() {
                                  if (widget.isCartScreen) {
                                    context.read<CartBloc>().add(
                                        UpdateItemInCart(
                                            widget.product, newQuantity));
                                  } else {
                                    widget.onQuantityChanged!(newQuantity);
                                  }
                                });
                              },
                            );
                          },
                          child: Container(
                            height: 35,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                vertical:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                            ),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.add, size: 24),
                            onPressed: () {
                              if (quantity < 999) {
                                if (widget.isCartScreen) {
                                  context
                                      .read<CartBloc>()
                                      .add(AddItemToCart(widget.product, 1));
                                } else {
                                  widget.onQuantityChanged!(quantity + 1);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: IconButton(
                      icon: const Icon(Icons.close_sharp, size: 17.5),
                      onPressed: widget.onClosePressed),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.price ?? formattedPrice} ₫',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.amber[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog({
    required BuildContext context,
    required String name,
    required int initialQuantity,
    required void Function(int) onQuantityChanged,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuantityDialog(
          name: name,
          initialQuantity: initialQuantity,
          onQuantityChanged: onQuantityChanged,
        );
      },
    );
  }
}
