import "package:flutter_test/flutter_test.dart";

import "package:shop_app/models/product.dart";
import "package:shop_app/models/cart_item.dart";
import "package:shop_app/models/order.dart";
import "package:shop_app/utils/crypto_utils.dart";

void main() {
  test("hashPassword is deterministic and non-plaintext", () {
    final h1 = hashPassword("123456");
    final h2 = hashPassword("123456");
    expect(h1, h2);
    expect(h1, isNot("123456"));
    expect(h1.length, 64);
  });

  test("CartItem line total multiplies price by quantity", () {
    final item = CartItem(
      product: const Product(id: "1", name: "A", description: "", price: 10),
      quantity: 3,
    );
    expect(item.lineTotal, 30);
  });

  test("ShopOrder.fromCart sums line totals", () {
    final cart = [
      CartItem(
          product: const Product(id: "1", name: "A", description: "", price: 10),
          quantity: 2),
      CartItem(
          product: const Product(id: "2", name: "B", description: "", price: 5),
          quantity: 4),
    ];
    final order = ShopOrder.fromCart(userEmail: "x@y.com", cart: cart);
    expect(order.total, 40);
    expect(order.items.length, 2);
  });
}

