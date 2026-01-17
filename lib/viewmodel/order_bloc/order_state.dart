part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderModel> orders;
  OrderSuccess(this.orders);
}

class OrderFailure extends OrderState {
  final String message;
  OrderFailure(this.message);
}
