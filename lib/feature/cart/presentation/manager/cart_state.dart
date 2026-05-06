abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<dynamic> items;
  final double subTotal;
  CartLoaded({required this.items, required this.subTotal});
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
