import 'package:avodha_interview_test/model/orderModel.dart';
import 'package:avodha_interview_test/viewmodel/order_bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllOrdersPage extends StatelessWidget {
  const ViewAllOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(ViewAllOrdersEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderFailure) {
            return Center(
              child: Text('Failed to load orders', textAlign: TextAlign.center),
            );
          } else if (state is OrderSuccess) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text('No orders placed yet'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final OrderModel order = orders[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withValues(alpha: 0.05),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    title: Text(
                      "${order.products.length} items",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Order ID: ${order.orderId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          'Payment: ${order.paymentMethod}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          'Address: ${order.address}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
