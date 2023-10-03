import 'package:api_flutter/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key,  required this.products});
  final List<ProductModel> products;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  List<ProductModel> productCart = [];

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var element in widget.products) {
      if (prefs.containsKey(element.title!)) {
        productCart.add(element);
      }
    }
    setState(() {});
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var product in productCart) {
      // Assuming the price is stored as a string, convert it to a double
      double price = double.tryParse(product.price!) ?? 0.0;
      totalPrice += price;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: productCart.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(productCart[index].image!),radius: 20,),
            title: Text(productCart[index].title!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${productCart[index].category!}'),
                Text('Price: \$${productCart[index].price}'),
              ],
            ),
            trailing: IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove(productCart[index].title!);
                productCart.remove(productCart[index]);
                setState(() {});
                // Notify the user that the product was removed from the cart
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product removed from cart'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.remove_circle_sharp),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items: ${productCart.length}',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Total Price: \$${calculateTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
