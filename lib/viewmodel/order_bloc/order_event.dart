part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class AddOrderEvent extends OrderEvent {
  final OrderModel order;
  AddOrderEvent(this.order);
}

class ViewAllOrdersEvent extends OrderEvent {}
