part of 'product_home_bloc.dart';

@immutable
sealed class ProductHomeEvent {}

class GetHomeDataEvent extends ProductHomeEvent {}
