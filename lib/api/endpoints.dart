class APIEndpoints {
  static String baseUrl = "https://dummyjson.com";

  static Map<String, String> endPoints = {
    "products": "$baseUrl/products",
    "productsLimit": "$baseUrl/products?limit=10",
    "productById": "$baseUrl/products/{id}",
    "productsSearch": "$baseUrl/products/search?q={query}",
    "productsCategories": "$baseUrl/products/categories",
    "productsByCategory": "$baseUrl/products/category/{category}",
  };
}
