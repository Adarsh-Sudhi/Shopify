part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Map<String, dynamic>> cartItems;
  CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
