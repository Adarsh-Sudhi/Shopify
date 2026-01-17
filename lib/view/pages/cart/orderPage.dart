import 'dart:developer';
import 'package:avodha_interview_test/model/orderModel.dart';
import 'package:avodha_interview_test/view/customWidget/toast.dart';
import 'package:avodha_interview_test/view/pages/cart/order_page.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  OrderSummaryPage({super.key, required this.products});

  double get totalPrice =>
      products.fold(0, (sum, item) => sum + (item['price'] as num).toDouble());

  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final product = Map<String, dynamic>.from(products[index]);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product['thumbnail'],
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\$${(product['price'] as num).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Items', style: TextStyle(fontSize: 14)),
                    Text(
                      products.length.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 16)),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

           
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: "Delivery Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_addressController.text.isEmpty) {
                        Utils().showToast("Address field is empty");
                        return;
                      }
                      List<ProductModel> productlist = [];
                      log(products.first.toString());

                      for (var prod in products) {
                        productlist.add(
                          ProductModel(
                            name: prod['title'],
                            description: prod['description'],
                            imageUrl: prod['images'].last,
                            quantity: prod["stock"],
                            discount: prod['discountPercentage'],
                          ),
                        );
                      }



                      showDialog(
                        context: context,
                        barrierDismissible: false, 
                        builder: (context) {
                          return Dialog(
                            insetPadding: const EdgeInsets.all(16),
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: OrderSuccessfulPage(
                                  totalPrice: totalPrice,
                                  address: _addressController.text.trim(),
                                  products: productlist,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },

                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
