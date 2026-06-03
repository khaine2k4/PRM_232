import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final String emoji;
  final double price;

  const MenuItem({required this.name, required this.emoji, required this.price});
}

class Lab4CoffeeShop extends StatefulWidget {
  const Lab4CoffeeShop({super.key});

  @override
  State<Lab4CoffeeShop> createState() => _Lab4CoffeeShopState();
}

class _Lab4CoffeeShopState extends State<Lab4CoffeeShop> {
  final List<MenuItem> _menu = const [
    MenuItem(name: 'Cà Phê', emoji: '☕', price: 2.0),
    MenuItem(name: 'Trà Sữa', emoji: '🧋', price: 3.5),
    MenuItem(name: 'Bánh Ngọt', emoji: '🍰', price: 2.5),
  ];

  final Map<String, int> _quantities = {
    'Cà Phê': 0,
    'Trà Sữa': 0,
    'Bánh Ngọt': 0,
  };

  double get _total {
    double total = 0;
    for (final item in _menu) {
      total += item.price * (_quantities[item.name] ?? 0);
    }
    return total;
  }

  int get _totalItems =>
      _quantities.values.fold(0, (sum, qty) => sum + qty);

  void _increase(String name) => setState(() => _quantities[name] = (_quantities[name] ?? 0) + 1);
  void _decrease(String name) => setState(() {
        if ((_quantities[name] ?? 0) > 0) {
          _quantities[name] = _quantities[name]! - 1;
        }
      });

  void _placeOrder() {
    if (_totalItems == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🛒 Chọn ít nhất 1 món!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1208),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '✅ Đặt Hàng Thành Công!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._menu
                .where((item) => (_quantities[item.name] ?? 0) > 0)
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.emoji} ${item.name} x${_quantities[item.name]}',
                            style: const TextStyle(color: Color(0xFFD97706)),
                          ),
                          Text(
                            '\$${(item.price * _quantities[item.name]!).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),
            const Divider(color: Color(0xFF78350F)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng:',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                for (final key in _quantities.keys) {
                  _quantities[key] = 0;
                }
              });
            },
            child: const Text('Đóng', style: TextStyle(color: Color(0xFFF59E0B))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0700),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E0F00),
        title: const Text(
          'Lab 4 – Coffee Shop ☕',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                if (_totalItems > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$_totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Hero Banner ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E0F00), Color(0xFF3D1A00)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chào buổi sáng! ☀️',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Hôm nay bạn muốn\nuống gì?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // ── Menu List ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'MENU',
                  style: TextStyle(
                    color: Color(0xFFD97706),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                ..._menu.map((item) => _MenuCard(
                      item: item,
                      quantity: _quantities[item.name]!,
                      onIncrease: () => _increase(item.name),
                      onDecrease: () => _decrease(item.name),
                    )),
              ],
            ),
          ),

          // ── Order Summary & Place Order ──
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E0F00),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Total row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng đơn hàng',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        '\$${_total.toStringAsFixed(2)}',
                        key: ValueKey(_total),
                        style: const TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Place order button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_rounded),
                        const SizedBox(width: 10),
                        Text(
                          _totalItems > 0
                              ? 'Đặt Hàng ($_totalItems món)'
                              : 'Chọn Món',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _MenuCard({
    required this.item,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = item.price * quantity;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E0F00),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: quantity > 0
              ? const Color(0xFFD97706).withValues(alpha: 0.5)
              : const Color(0xFF3D1A00),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Emoji icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF3D1A00),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),

          // Name & price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFFD97706),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (quantity > 0) ...[
                      const Text(
                        ' → ',
                        style: TextStyle(color: Color(0xFF78350F)),
                      ),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Quantity controls
          Row(
            children: [
              _QtyButton(
                icon: Icons.remove_rounded,
                onTap: onDecrease,
                enabled: quantity > 0,
              ),
              SizedBox(
                width: 36,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    '$quantity',
                    key: ValueKey(quantity),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _QtyButton(
                icon: Icons.add_rounded,
                onTap: onIncrease,
                enabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFD97706).withValues(alpha: 0.2)
              : const Color(0xFF3D1A00),
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? const Color(0xFFD97706).withValues(alpha: 0.5)
                : const Color(0xFF3D1A00),
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFFD97706) : const Color(0xFF78350F),
          size: 18,
        ),
      ),
    );
  }
}
