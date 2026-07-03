import "product.dart";

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
        "productId": product.id,
        "name": product.name,
        "price": product.price,
        "quantity": quantity,
        "lineTotal": lineTotal,
      };
}
