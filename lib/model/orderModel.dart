// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderModel {
  final String orderId;
  final String paymentMethod;
  final String address;
  final double price;
  final List<ProductModel> products;

  OrderModel({
    required this.orderId,
    required this.paymentMethod,
    required this.address,
    required this.price,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'paymentMethod': paymentMethod,
      'address': address,
      'price': price,
      'products': products
          .map((p) => p.toMap())
          .toList(), // ✅ convert each product to Map
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      address: map['address'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      products: (map['products'] as List<dynamic>? ?? [])
          .map((p) => ProductModel.fromMap(Map<String, dynamic>.from(p)))
          .toList(), // ✅ convert each Map back to ProductModel
    );
  }
}

class ProductModel {
  final String name;
  final String description;
  final String imageUrl;
  final int quantity;
  final double discount; // as percentage

  ProductModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.quantity,
    required this.discount,
  });

  /// Convert ProductModel to Map (for Hive or JSON)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'discount': discount,
    };
  }

  /// Create ProductModel from Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 0,
      discount: (map['discount'] ?? 0).toDouble(),
    );
  }
}
