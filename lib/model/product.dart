import 'dart:convert';

Product productFromMap(String str) => Product.fromMap(json.decode(str));

String productToMap(Product data) => json.encode(data.toMap());

class Product {
  final List<ProductElement> products;
  final int total;
  final int skip;
  final int limit;

  Product({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    products: List<ProductElement>.from(
      json["products"].map((x) => ProductElement.fromMap(x)),
    ),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toMap() => {
    "products": List<dynamic>.from(products.map((x) => x.toMap())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class ProductElement {
  final int id;
  final String title;
  final String description;
  final Category? category;
  final double price;
  final double discountPercentage;
  final double rating;
  int stock;
  final List<String> tags;
  final String? brand;
  final String sku;
  final int weight;
  final String? warrantyInformation;
  final String? shippingInformation;
  final AvailabilityStatus? availabilityStatus;
  final List<Review> reviews;
  final String? returnPolicy;
  final int minimumOrderQuantity;
  final Meta? meta;
  final List<String> images;
  final String thumbnail;

  ProductElement({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    required this.sku,
    required this.weight,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    required this.reviews,
    this.returnPolicy,
    required this.minimumOrderQuantity,
    this.meta,
    required this.images,
    required this.thumbnail,
  });

  factory ProductElement.fromMap(Map<dynamic, dynamic> json) {
    return ProductElement(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      category: categoryValues.map[json["category"]],
      price: (json["price"] ?? 0).toDouble(),
      discountPercentage: (json["discountPercentage"] ?? 0).toDouble(),
      rating: (json["rating"] ?? 0).toDouble(),
      stock: json["stock"] ?? 0,
      tags: json["tags"] != null ? List<String>.from(json["tags"]) : [],
      brand: json["brand"],
      sku: json["sku"] ?? "",
      weight: json["weight"] ?? 0,

      warrantyInformation: json["warrantyInformation"],
      shippingInformation: json["shippingInformation"],
      availabilityStatus:
          availabilityStatusValues.map[json["availabilityStatus"]],
      reviews: json["reviews"] != null
          ? List<Review>.from(json["reviews"].map((x) => Review.fromMap(x)))
          : [],
      returnPolicy: json["returnPolicy"],
      minimumOrderQuantity: json["minimumOrderQuantity"] ?? 1,
      meta: json["meta"] != null ? Meta.fromMap(json["meta"]) : null,
      images: json["images"] != null ? List<String>.from(json["images"]) : [],
      thumbnail: json["thumbnail"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "category": categoryValues.reverse[category],
      "price": price,
      "discountPercentage": discountPercentage,
      "rating": rating,
      "stock": stock,
      "tags": tags,
      "brand": brand,
      "sku": sku,
      "weight": weight,
      "warrantyInformation": warrantyInformation,
      "shippingInformation": shippingInformation,
      "availabilityStatus":
          availabilityStatusValues.reverse[availabilityStatus],
      "reviews": reviews.map((x) => x.toMap()).toList(),
      "returnPolicy": returnPolicy,
      "minimumOrderQuantity": minimumOrderQuantity,
      "meta": meta?.toMap(),
      "images": images,
      "thumbnail": thumbnail,
    };
  }
}

enum AvailabilityStatus { IN_STOCK, LOW_STOCK }

final availabilityStatusValues = EnumValues({
  "In Stock": AvailabilityStatus.IN_STOCK,
  "Low Stock": AvailabilityStatus.LOW_STOCK,
});

enum Category { BEAUTY, FRAGRANCES, FURNITURE, GROCERIES }

final categoryValues = EnumValues({
  "beauty": Category.BEAUTY,
  "fragrances": Category.FRAGRANCES,
  "furniture": Category.FURNITURE,
  "groceries": Category.GROCERIES,
});

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({required this.width, required this.height, required this.depth});

  factory Dimensions.fromMap(Map<String, dynamic> json) {
    return Dimensions(
      width: (json["width"] ?? 0).toDouble(),
      height: (json["height"] ?? 0).toDouble(),
      depth: (json["depth"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {"width": width, "height": height, "depth": depth};
  }
}

class Meta {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory Meta.fromMap(Map<dynamic, dynamic> json) {
    return Meta(
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
      barcode: json["barcode"] ?? "",
      qrCode: json["qrCode"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "barcode": barcode,
      "qrCode": qrCode,
    };
  }
}

class Review {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromMap(Map<String, dynamic> json) {
    return Review(
      rating: json["rating"] ?? 0,
      comment: json["comment"] ?? "",
      date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
      reviewerName: json["reviewerName"] ?? "",
      reviewerEmail: json["reviewerEmail"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "rating": rating,
      "comment": comment,
      "date": date.toIso8601String(),
      "reviewerName": reviewerName,
      "reviewerEmail": reviewerEmail,
    };
  }
}

class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map) {
    reverseMap = map.map((k, v) => MapEntry(v, k));
  }

  Map<T, String> get reverse => reverseMap;
}
