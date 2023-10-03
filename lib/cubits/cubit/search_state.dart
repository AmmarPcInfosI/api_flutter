part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}
class SearchSuccessState extends SearchState {}
class SearchLoadingState extends SearchState {}
class SearchErrorState extends SearchState {}
class SearchProductState extends SearchState {
  final List<ProductModel> filteredProducts;

  SearchProductState({required this.filteredProducts});
}