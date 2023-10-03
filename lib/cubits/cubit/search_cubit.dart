import 'package:api_flutter/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
   static SearchCubit get(context) => BlocProvider.of(context);

  List<ProductModel> products = [];

  List<ProductModel> searchProducts = [];

  void search(String text) {
    searchProducts = products
        .where((element) =>
            element.title!.toLowerCase().contains(text.toLowerCase()))
        .toList();

    emit((SearchProductState(filteredProducts: searchProducts)));
  }

  Dio dio = Dio();

  void getProduct() {
    emit(SearchLoadingState());
    dio.get("https://fakestoreapi.com/products").then((value) {
      if (value.statusCode == 200) {
        for (var element in value.data) {
          products.add(ProductModel.fromJson(element));
        }

        emit(SearchSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
