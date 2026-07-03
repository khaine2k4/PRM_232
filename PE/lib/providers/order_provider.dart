import "package:flutter/foundation.dart";

import "../data/order_repository.dart";
import "../models/cart_item.dart";
import "../models/order.dart";

enum RevenueFilter { all, day, month, year }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repo;
  OrderProvider({OrderRepository? repo}) : _repo = repo ?? OrderRepository();

  List<ShopOrder> _orders = [];
  bool _loading = false;
  String? _error;
  RevenueFilter _filter = RevenueFilter.all;
  DateTime _anchor = DateTime.now();

  bool get loading => _loading;
  String? get error => _error;
  RevenueFilter get filter => _filter;
  DateTime get anchor => _anchor;
  List<ShopOrder> get orders => List.unmodifiable(_filteredOrders);

  List<ShopOrder> get _filteredOrders {
    return _orders.where((o) {
      switch (_filter) {
        case RevenueFilter.all:
          return true;
        case RevenueFilter.day:
          return o.createdAt.year == _anchor.year &&
              o.createdAt.month == _anchor.month &&
              o.createdAt.day == _anchor.day;
        case RevenueFilter.month:
          return o.createdAt.year == _anchor.year &&
              o.createdAt.month == _anchor.month;
        case RevenueFilter.year:
          return o.createdAt.year == _anchor.year;
      }
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  double get totalRevenue =>
      _filteredOrders.fold(0.0, (sum, o) => sum + o.total);
  int get orderCount => _filteredOrders.length;
  int get itemsSold => _filteredOrders.fold(
      0, (sum, o) => sum + o.items.fold(0, (s, i) => s + i.quantity));

  void setFilter(RevenueFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setAnchor(DateTime date) {
    _anchor = date;
    notifyListeners();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _orders = await _repo.fetchAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<ShopOrder> checkout({
    required String userEmail,
    required List<CartItem> cart,
  }) async {
    final order = ShopOrder.fromCart(userEmail: userEmail, cart: cart);
    final saved = await _repo.create(order);
    _orders = [..._orders, saved];
    notifyListeners();
    return saved;
  }
}
