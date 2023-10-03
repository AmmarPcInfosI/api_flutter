import 'package:api_flutter/screens/search_login.dart';
import 'package:flutter/material.dart';

import 'package:api_flutter/cubits/cubit/product_cubit.dart';
import 'package:api_flutter/screens/cart_screen.dart';
import 'package:api_flutter/screens/home_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _productsLoaded = false; // Add this variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping App'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          final cubit = ProductCubit.get(context);

          // Check if products have been loaded, if not, load them
          if (!_productsLoaded) {
            cubit.getProducts();
            _productsLoaded = true;
          }

          final List<Widget> screens = [
            const HomeScreen(),
            const SearchScreen(),
            CartScreen(products: cubit.products),
          ];

          return screens[_currentIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
