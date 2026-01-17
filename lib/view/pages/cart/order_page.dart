// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:avodha_interview_test/view/pages/cart/all_orders.dart';
import 'package:avodha_interview_test/viewmodel/order_bloc/order_bloc.dart';
import 'package:flutter/material.dart';

import 'package:avodha_interview_test/model/orderModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderSuccessfulPage extends StatefulWidget {
  final String address;
  final double totalPrice;
  final List<ProductModel> products;
  const OrderSuccessfulPage({
    super.key,
    required this.address,
    required this.totalPrice,
    required this.products,
  });

  @override
  State<OrderSuccessfulPage> createState() => _OrderSuccessfulPageState();
}

class _OrderSuccessfulPageState extends State<OrderSuccessfulPage> {
  @override
  void initState() {
    super.initState();
    OrderModel orderModel = OrderModel(
      orderId: (Random().nextInt(10000) + 100000).toString(),
      paymentMethod: "Online",
      address: widget.address,
      price: widget.totalPrice,
      products: widget.products,
    );

    BlocProvider.of<OrderBloc>(context).add(AddOrderEvent(orderModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),

              const SizedBox(height: 24),

            
              const Text(
                'Order Successful!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Text(
                'Thank you for your purchase.\nYour order has been placed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

           
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _infoRow('Order ID', '#ORD123456'),
                    const SizedBox(height: 8),
                    _infoRow('Estimated Delivery', '3–5 Business Days'),
                    const SizedBox(height: 8),
                    _infoRow('Payment Method', 'Online Payment'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              
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
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewAllOrdersPage()),
                  );
                },
                child: const Text(
                  'View My Orders',
                  style: TextStyle(fontSize: 14, color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
