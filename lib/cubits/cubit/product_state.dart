part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}
class getProductLoadingState extends ProductState {}
class getProductSuccessState extends ProductState {}
class getProductErrorState extends ProductState {}
