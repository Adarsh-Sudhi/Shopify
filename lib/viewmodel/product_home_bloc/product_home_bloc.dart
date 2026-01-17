import 'dart:convert';
import 'dart:developer';
import 'package:avodha_interview_test/api/endpoints.dart';
import 'package:avodha_interview_test/model/category.dart';
import 'package:avodha_interview_test/model/product.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'product_home_event.dart';
part 'product_home_state.dart';

class ProductHomeBloc extends Bloc<ProductHomeEvent, ProductHomeState> {
  ProductHomeBloc() : super(ProductHomeInitial()) {
    on<GetHomeDataEvent>((event, emit) async {
      try {
        emit(ProductHomeLoading());
        List<Categories> categoriesMap = [];
        List<ProductElement> products = [];

        log(APIEndpoints.endPoints['productsCategories']!);
        log(APIEndpoints.endPoints['productsLimit']!.replaceAll("10", "20"));

        final categoryResponse = await http.get(
          Uri.parse(APIEndpoints.endPoints['productsCategories']!),
        );

        if (categoryResponse.statusCode == 200) {
          List<dynamic> categories = jsonDecode(categoryResponse.body);
          for (var e in categories) {
            categoriesMap.add(Categories.fromMap(e));
          }
        }

        final featuredResponse = await http.get(
          Uri.parse(
            APIEndpoints.endPoints['productsLimit']!.replaceAll("10", "20"),
          ),
        );

        if (featuredResponse.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(featuredResponse.body);
          for (var e in (data['products'] as List<dynamic>)) {
            products.add(ProductElement.fromMap(e));
          }
        }

        log(
          "Featured Products: ${products.length}, Categories: $categoriesMap",
        );

        emit(HomeProductDetails(categoriesMap, products));
      } catch (e) {
        print("Error fetching home data: $e");
      }
    });
  }
}
