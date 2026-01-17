part of 'product_home_bloc.dart';

@immutable
sealed class ProductHomeState {}

final class ProductHomeInitial extends ProductHomeState {}

final class ProductHomeLoading extends ProductHomeState {}

final class HomeProductDetails extends ProductHomeState {
  final List<Categories> categoriesMap;
  final List<ProductElement> products;

  HomeProductDetails(this.categoriesMap, this.products);
}
