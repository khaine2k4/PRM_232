import "cart_item.dart";

class OrderLine {
  final String? productId;
  final String name;
  final double price;
  final int quantity;

  const OrderLine({
    this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
        productId: json["productId"]?.toString(),
        name: (json["name"] ?? "") as String,
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        quantity: (json["quantity"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "price": price,
        "quantity": quantity,
      };
}

class ShopOrder {
  final String? id;
  final String userEmail;
  final List<OrderLine> items;
  final double total;
  final DateTime createdAt;

  const ShopOrder({
    this.id,
    required this.userEmail,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  factory ShopOrder.fromCart({
    required String userEmail,
    required List<CartItem> cart,
  }) {
    final lines = cart
        .map((c) => OrderLine(
              productId: c.product.id,
              name: c.product.name,
              price: c.product.price,
              quantity: c.quantity,
            ))
        .toList();
    final total = lines.fold<double>(0, (sum, l) => sum + l.lineTotal);
    return ShopOrder(
      userEmail: userEmail,
      items: lines,
      total: total,
      createdAt: DateTime.now(),
    );
  }

  factory ShopOrder.fromJson(Map<String, dynamic> json) => ShopOrder(
        id: json["id"]?.toString(),
        userEmail: (json["userEmail"] ?? "") as String,
        items: ((json["items"] ?? []) as List)
            .map((e) => OrderLine.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: (json["total"] as num?)?.toDouble() ?? 0.0,
        createdAt:
            DateTime.tryParse((json["createdAt"] ?? "") as String) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "userEmail": userEmail,
        "items": items.map((e) => e.toJson()).toList(),
        "total": total,
        "createdAt": createdAt.toIso8601String(),
      };
}
