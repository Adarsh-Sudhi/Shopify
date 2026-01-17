part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class AddToCart extends CartEvent {
  final String email;
  final Map<String, dynamic> product;
  AddToCart({required this.email, required this.product});
}

class RemoveFromCart extends CartEvent {
  final String email;
  final String productId;
  RemoveFromCart({required this.email, required this.productId});
}

class GetAllCartItems extends CartEvent {
  final String email;
  GetAllCartItems({required this.email});
}
