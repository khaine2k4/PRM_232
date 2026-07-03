class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String image; // URL or local file path (may be empty)

  const Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image = "",
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"]?.toString(),
        name: (json["name"] ?? "") as String,
        description: (json["description"] ?? "") as String,
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        image: (json["image"] ?? "") as String,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "image": image,
      };

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        image: image ?? this.image,
      );
}
