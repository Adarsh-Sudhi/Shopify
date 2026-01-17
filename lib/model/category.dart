import 'dart:convert';

List<Categories> categoriesFromMap(String str) =>
    List<Categories>.from(json.decode(str).map((x) => Categories.fromMap(x)));

String categoriesToMap(List<Categories> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Categories {
  final String slug;
  final String name;
  final String url;

  Categories({required this.slug, required this.name, required this.url});

  factory Categories.fromMap(Map<String, dynamic> json) =>
      Categories(slug: json["slug"], name: json["name"], url: json["url"]);

  Map<String, dynamic> toMap() => {"slug": slug, "name": name, "url": url};
}
