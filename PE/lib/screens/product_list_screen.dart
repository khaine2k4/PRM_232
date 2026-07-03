import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "../models/product.dart";
import "../providers/auth_provider.dart";
import "../providers/cart_provider.dart";
import "../providers/product_provider.dart";
import "../utils/formatters.dart";

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().load();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          if (auth.isAdmin)
            IconButton(
              tooltip: "Revenue",
              icon: const Icon(Icons.bar_chart),
              onPressed: () => context.push("/revenue"),
            ),
          _CartButton(count: cart.totalQuantity),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "logout") {
                await auth.logout();
                if (context.mounted) context.go("/login");
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(auth.currentUser?.fullName ?? "Guest"),
                    Text(
                      auth.isAdmin ? "Admin" : "Customer",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: "logout",
                child: Text("Logout"),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: auth.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context.push("/products/new"),
              icon: const Icon(Icons.add),
              label: const Text("Add"),
            )
          : null,
      body: Column(
        children: [
          _SearchAndSortBar(controller: _searchCtrl),
          Expanded(child: _buildBody(products)),
        ],
      ),
    );
  }

  Widget _buildBody(ProductProvider products) {
    if (products.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products.error != null) {
      return _ErrorView(
        message: products.error!,
        onRetry: () => products.load(),
      );
    }
    final list = products.visibleProducts;
    if (list.isEmpty) {
      return const Center(child: Text("No products found."));
    }
    return RefreshIndicator(
      onRefresh: () => products.load(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: list.length,
        itemBuilder: (context, index) =>
            _ProductTile(product: list[index]),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  final int count;
  const _CartButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          tooltip: "Cart",
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => context.push("/cart"),
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints:
                  const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                "$count",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchAndSortBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchAndSortBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: provider.search,
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: const OutlineInputBorder(),
                suffixIcon: provider.query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          provider.search("");
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<SortOrder>(
            tooltip: "Sort by price",
            icon: Icon(
              Icons.sort,
              color: provider.sort == SortOrder.none
                  ? null
                  : Theme.of(context).colorScheme.primary,
            ),
            initialValue: provider.sort,
            onSelected: provider.setSort,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: SortOrder.none,
                child: Text("Default order"),
              ),
              PopupMenuItem(
                value: SortOrder.priceAsc,
                child: Text("Price: Low to High"),
              ),
              PopupMenuItem(
                value: SortOrder.priceDesc,
                child: Text("Price: High to Low"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () => context.push("/products/${product.id}", extra: product),
        leading: _Thumb(url: product.image),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          product.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatCurrency(product.price),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart, size: 20),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(),
              tooltip: "Add to cart",
              onPressed: () {
                context.read<CartProvider>().add(product);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("${product.name} added to cart"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  const _Thumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 56,
        height: 56,
        child: url.isEmpty
            ? Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported_outlined),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

