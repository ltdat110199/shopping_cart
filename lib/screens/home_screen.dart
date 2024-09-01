import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/bloc/cart_bloc.dart';
import 'package:shopping_cart/repository/product_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shopping_cart/screens/cart_screen.dart';

import '../bloc/cart_state.dart';
import '../models/product.dart';
import '../widgets/add_to_cart_bottom_sheet.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductRepository productRepository = ProductRepository();
  Color borderColor = Colors.grey;

  List<Product> products = [];
  int _pn = 1;
  bool _isLoading = false;
  bool isTablet = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await EasyLoading.show(maskType: EasyLoadingMaskType.black);
      await _fetchItems();
      await EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productIsHot =
        productRepository.products.where((product) => product.isHot).toList();
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;
    isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AppBar(
            title: const Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.amber[700],
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Stack(
                      children: [
                        const SizedBox(
                          width: 40,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 30,
                          ),
                        ),
                        if (state.items.isNotEmpty)
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: 21,
                              height: 21,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                state.itemCount > 99
                                    ? '99+'
                                    : '${state.itemCount}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()),
                      );
                    },
                  );
                },
              ),
            ]),
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!_isLoading &&
                products.length < productRepository.products.length &&
                scrollInfo.metrics.pixels >
                    scrollInfo.metrics.maxScrollExtent - 200) {
              setState(() {
                _isLoading = true;
              });
              _fetchItems();
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            strokeWidth: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                'HOT Products',
                                style: TextStyle(
                                    color: Colors.amber[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 220,
                          width: MediaQuery.of(context).size.width,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int itemCount =
                                  constraints.maxWidth > 600 ? 4 : 2;
                              double itemWidth =
                                  constraints.maxWidth / itemCount;

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 12,
                                ),
                                itemCount: productIsHot.length,
                                itemBuilder: (context, index) {
                                  final product = productIsHot[index];
                                  return SizedBox(
                                      width: itemWidth,
                                      child: ProductCard(
                                          product: product,
                                          isHot: product.isHot,
                                          onAddToCart: () {
                                            _showAddToCartBottomSheet(
                                                context, product);
                                          }));
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Text(
                            'ALL Products',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[900]),
                          ),
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 220),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              onAddToCart: () {
                                _showAddToCartBottomSheet(context, product);
                              },
                            );
                          },
                        ),
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchItems() async {
    if (mounted) {
      int itemsToFetch = isTablet ? 16 : 10;
      final startIndex = itemsToFetch * (_pn - 1);
      final endIndex = itemsToFetch * _pn;
      final totalItems = productRepository.products.length;
      final actualEndIndex = endIndex > totalItems ? totalItems : endIndex;
      if (startIndex < totalItems) {
        await Future<void>.delayed(const Duration(milliseconds: 1000));
        final newProducts = productRepository.getProducts(
            startIndex, actualEndIndex - startIndex);
        setState(() {
          products.addAll(newProducts);
        });
        _pn++;
      } else {}
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddToCartBottomSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return AddToCartBottomSheet(product: product);
      },
    );
  }

  Future<void> _onRefresh() async {
    await HapticFeedback.heavyImpact();
    _pn = 1;
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    setState(() {
      products.clear();
    });
    await _fetchItems();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    _isLoading = false;
  }
}
