import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "../models/order.dart";
import "../providers/order_provider.dart";
import "../utils/formatters.dart";

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().load();
    });
  }

  String _anchorLabel(OrderProvider p) {
    switch (p.filter) {
      case RevenueFilter.all:
        return "All time";
      case RevenueFilter.day:
        return DateFormat("dd/MM/yyyy").format(p.anchor);
      case RevenueFilter.month:
        return DateFormat("MM/yyyy").format(p.anchor);
      case RevenueFilter.year:
        return DateFormat("yyyy").format(p.anchor);
    }
  }

  Future<void> _pickAnchor(OrderProvider p) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: p.anchor,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) p.setAnchor(picked);
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue statistics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => orders.load(),
          ),
        ],
      ),
      body: orders.loading
          ? const Center(child: CircularProgressIndicator())
          : orders.error != null
              ? Center(child: Text(orders.error!))
              : Column(
                  children: [
                    _FilterBar(
                      filter: orders.filter,
                      onChanged: orders.setFilter,
                    ),
                    if (orders.filter != RevenueFilter.all)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text("Period: ${_anchorLabel(orders)}"),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => _pickAnchor(orders),
                              icon: const Icon(Icons.calendar_today, size: 16),
                              label: const Text("Change"),
                            ),
                          ],
                        ),
                      ),
                    _SummaryCards(orders: orders),
                    const Divider(height: 1),
                    Expanded(child: _OrderList(orders: orders.orders)),
                  ],
                ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final RevenueFilter filter;
  final ValueChanged<RevenueFilter> onChanged;
  const _FilterBar({required this.filter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SegmentedButton<RevenueFilter>(
        segments: const [
          ButtonSegment(value: RevenueFilter.all, label: Text("All")),
          ButtonSegment(value: RevenueFilter.day, label: Text("Day")),
          ButtonSegment(value: RevenueFilter.month, label: Text("Month")),
          ButtonSegment(value: RevenueFilter.year, label: Text("Year")),
        ],
        selected: {filter},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final OrderProvider orders;
  const _SummaryCards({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _StatCard(
            label: "Total revenue",
            value: formatCurrency(orders.totalRevenue),
            icon: Icons.attach_money,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: "Orders",
            value: "${orders.orderCount}",
            icon: Icons.receipt_long,
            color: Colors.indigo,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: "Items sold",
            value: "${orders.itemsSold}",
            icon: Icons.inventory_2_outlined,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 4),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<ShopOrder> orders;
  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text("No orders in this period."));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
        return ExpansionTile(
          leading: const Icon(Icons.receipt),
          title: Text("Order #${o.id}  -  ${formatCurrency(o.total)}"),
          subtitle: Text(formatDate(o.createdAt)),
          children: o.items
              .map(
                (line) => ListTile(
                  dense: true,
                  title: Text(line.name),
                  trailing: Text(
                      "${line.quantity} x ${formatCurrency(line.price)}"),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
