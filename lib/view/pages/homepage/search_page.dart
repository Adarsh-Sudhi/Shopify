import 'dart:convert';
import 'dart:developer';
import 'package:avodha_interview_test/model/product.dart';
import 'package:avodha_interview_test/view/customWidget/CachedNetWorkImage.dart';
import 'package:avodha_interview_test/view/pages/productspage/productPageView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProductsPage extends StatefulWidget {
  final String search;

  const SearchProductsPage({super.key, required this.search});

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  bool isLoading = true;
  List<ProductElement> products = [];
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    try {
      final url = 'https://dummyjson.com/products/search?q=${widget.search}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final res = List.from(data['products']);

        setState(() {
          products = res
              .map((e) => ProductElement.fromMap(e))
              .toList();
          isLoading = false;
        });

        log('Products count: ${products.length}');
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        title: Text(
          'Results for "${widget.search}"',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : products.isEmpty
          ? const Center(child: Text('No products found'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (_) => ProductViewPage(product: product)));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: product.id,
                          child: AppCachedImage(
                           imageUrl:  product.images.last,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '\$${product.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
