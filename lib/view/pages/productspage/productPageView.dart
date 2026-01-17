
import 'dart:ui';
import 'package:avodha_interview_test/model/product.dart';
import 'package:avodha_interview_test/view/customWidget/CachedNetWorkImage.dart';
import 'package:avodha_interview_test/viewmodel/cart_bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ProductViewPage extends StatefulWidget {
  final ProductElement product;

  const ProductViewPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 350,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.id,
                    child: AppCachedImage(
                      imageUrl: product.images.isNotEmpty
                          ? product.images[0]
                          : product.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              stretchModes: [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(width: 10),
                        if (product.discountPercentage > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "${product.rating} / 5",
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Stock: ${product.stock}",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Text(
                          "Category: ",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          categoryValues.reverse[product.category] ?? "",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Text(
                          "Quantity: ",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.black87),
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) quantity--;
                                  });
                                },
                              ),
                              Text(
                                "$quantity",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.black87),
                                onPressed: () {
                                  if (widget.product.stock != quantity) {
                                    setState(() {
                                      quantity++;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final session = Hive.box("sessionBox");
                              final email = session.get("email");

                              widget.product.stock - quantity;

                              final productForCart = {
                                ...widget.product.toMap(),
                                'stock': quantity,
                              };

                              BlocProvider.of<CartBloc>(context).add(
                                AddToCart(
                                  email: email,
                                  product: productForCart,
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    if (product.reviews.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reviews",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...product.reviews.map(
                            (review) => Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        review.reviewerName,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: List.generate(
                                          review.rating,
                                          (index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    review.comment,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
