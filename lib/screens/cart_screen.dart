import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping_cart/bloc/cart_state.dart';
import 'package:shopping_cart/screens/home_screen.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../widgets/product_info.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final items = state.items;
        final formattedTotalAmount =
            NumberFormat('#,##0').format(state.totalAmount);
        return Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: AppBar(
                  title: Text(
                    'Cart (${state.itemCount})',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.amber[700],
                  iconTheme: const IconThemeData(color: Colors.white),
                  leading: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 24, color: Colors.white)),
                )),
            body: SafeArea(
                child: Column(
              children: [
                if (items.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (ctx, i) {
                          final item = items[i];
                          final totalPrice = item.quantity * item.product.price;
                          final formattedPrice =
                              NumberFormat('#,##0').format(totalPrice);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ProductInfo(
                                  product: item.product,
                                  quantity: item.quantity,
                                  isCartScreen: true,
                                  price: formattedPrice,
                                  onClosePressed: () {
                                    context
                                        .read<CartBloc>()
                                        .add(RemoveItemFromCart(
                                          item.product,
                                        ));
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                      ),
                    ),
                  ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 2,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Total price',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '$formattedTotalAmount ₫',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            if (state.items.isNotEmpty) {
                              context.read<CartBloc>().add(ClearCart());
                              _showOrderSuccessDialog(context);
                            }
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: state.items.isNotEmpty
                                  ? Colors.amber[700]
                                  : Colors.grey[700],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: const Text(
                              'Order',
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
            )));
      },
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              insetPadding: const EdgeInsets.all(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Order successfully!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.amber[700],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: const Text(
                                  'Back to Home',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
