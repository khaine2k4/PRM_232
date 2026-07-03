import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "../models/product.dart";
import "../providers/auth_provider.dart";
import "../providers/cart_provider.dart";
import "../providers/product_provider.dart";
import "../utils/formatters.dart";

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  Future<void> _confirmDelete(BuildContext context) async {
    final products = context.read<ProductProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete product"),
        content: Text("Remove \"${product.name}\" permanently?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await products.remove(product.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product deleted")),
        );
        context.pop();
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product details"),
        actions: [
          if (context.watch<AuthProvider>().isAdmin) ...[
            IconButton(
              tooltip: "Edit",
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  context.push("/products/${product.id}/edit", extra: product),
            ),
            IconButton(
              tooltip: "Delete",
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: product.image.isEmpty
                ? Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_outlined,
                        size: 64),
                  )
                : Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image_outlined, size: 64),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(product.price),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text("Description",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  product.description.isEmpty
                      ? "No description."
                      : product.description,
                  style: const TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () {
              context.read<CartProvider>().add(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product.name} added to cart"),
                  action: SnackBarAction(
                    label: "View cart",
                    onPressed: () => context.push("/cart"),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Add to cart"),
            ),
          ),
        ),
      ),
    );
  }
}




