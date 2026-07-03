import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/cart_item.dart";
import "../providers/auth_provider.dart";
import "../providers/cart_provider.dart";
import "../providers/order_provider.dart";
import "../utils/formatters.dart";

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final orders = context.read<OrderProvider>();
    final auth = context.read<AuthProvider>();
    if (cart.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm order"),
        content: Text(
            "Place order for ${cart.totalQuantity} item(s), total ${formatCurrency(cart.totalPrice)}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Checkout"),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final order = await orders.checkout(
        userEmail: auth.currentUser?.email ?? "guest",
        cart: cart.items,
      );
      cart.clear();
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Order placed"),
          content: Text(
              "Order #${order.id} confirmed.\nTotal: ${formatCurrency(order.total)}"),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Done"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: cart.items.length,
              itemBuilder: (context, index) =>
                  _CartRow(item: cart.items[index]),
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          formatCurrency(cart.totalPrice),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _checkout(context),
                      icon: const Icon(Icons.payment),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Checkout"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  const _CartRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final id = item.product.id!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                      "${formatCurrency(item.product.price)}  x  ${item.quantity}"),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency(item.lineTotal),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => cart.decrement(id),
                    ),
                    Text("${item.quantity}",
                        style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => cart.increment(id),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => cart.remove(id),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text("Remove"),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

