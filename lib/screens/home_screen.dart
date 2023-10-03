import 'dart:convert';

import 'package:api_flutter/cubits/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _productsLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkProductsLoaded();
  }

  Future<void> _checkProductsLoaded() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _productsLoaded = prefs.getBool('productsLoaded') ?? false;
    });

    if (!_productsLoaded) {
      // If products haven't been loaded, load them
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    var cubit = BlocProvider.of<ProductCubit>(context);
    cubit.getProducts();

    // Set the flag to true and save it in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('productsLoaded', true);
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ProductCubit>(context);

    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return state is getProductLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state is getProductErrorState
                  ? const Center(
                      child: Text("Error"),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(cubit.products[index].image!),
                                height: 100,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cubit.products[index].title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(cubit.products[index].category!),
                                          Text(cubit.products[index].price!),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String data =
                                              jsonEncode(cubit.products[index]);
                                          prefs.setString(
                                              cubit.products[index].title!,
                                              data);
                                          // Notify the user that the product was added to the cart
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Product added to cart'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.shopping_cart_checkout),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: cubit.products.length,
                    );
        },
      ),
    );
  }
}
