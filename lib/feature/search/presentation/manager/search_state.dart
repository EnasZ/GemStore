import 'package:gemstore/core/common/entities/product_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchSuccess extends SearchState {
  final List<ProductEntity> products;
  SearchSuccess({required this.products});
}
