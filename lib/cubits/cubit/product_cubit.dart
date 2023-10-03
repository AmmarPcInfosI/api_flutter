import 'package:api_flutter/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());
  static ProductCubit get(context) => BlocProvider.of(context);
  List<ProductModel> products = [];
  Dio dio = Dio();
  void getProducts() {
    emit(getProductLoadingState());
    dio.get("https://fakestoreapi.com/products").then((value) {
      if (value.statusCode == 200) {
        for (var element in value.data) {
          products.add(ProductModel.fromJson(element));
        }

        emit(getProductSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(getProductErrorState());
    });
  }
}
