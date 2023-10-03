import 'package:api_flutter/cubits/cubit/product_cubit.dart';
import 'package:api_flutter/cubits/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = ProductCubit.get(context);
    var cubittt = SearchCubit.get(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(
              controller: controller,
              onChanged: (value) {
                // Debounce the search to prevent frequent API requests
                if (_debounceTimer != null) {
                  _debounceTimer!.cancel();
                }
                _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                  cubittt.search(value);
                });
              },
              trailing: [
                IconButton(
                  onPressed: () {
                    // Trigger search immediately when the search button is pressed
                    cubittt.search(controller.text);
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchErrorState) {
                  return const Center(child: Text("Error occurred"));
                } else {
                  final searchProducts = state is SearchProductState
                      ? state.filteredProducts
                      : []; // Get filtered products from state

                  if (searchProducts.isEmpty) {
                    return const Center(child: Text("No items"));
                  } else {
                    return ListView.builder(
                      itemCount: searchProducts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            searchProducts[index].image!,
                          ),
                          title: Text(searchProducts[index].title!),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(searchProducts[index].category!),
                              Text(searchProducts[index].price!),
                            ],
                          ),
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
