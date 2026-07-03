import "package:flutter/foundation.dart";

import "../data/product_repository.dart";
import "../models/product.dart";

enum SortOrder { none, priceAsc, priceDesc }

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repo;
  ProductProvider({ProductRepository? repo})
      : _repo = repo ?? ProductRepository();

  List<Product> _all = [];
  bool _loading = false;
  String? _error;
  String _query = "";
  SortOrder _sort = SortOrder.none;

  bool get loading => _loading;
  String? get error => _error;
  String get query => _query;
  SortOrder get sort => _sort;
  int get count => visibleProducts.length;

  /// Products after applying the search filter and the sort order.
  List<Product> get visibleProducts {
    var list = _all.where((p) {
      if (_query.isEmpty) return true;
      return p.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    switch (_sort) {
      case SortOrder.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOrder.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOrder.none:
        break;
    }
    return list;
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _repo.fetchAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _query = query;
    notifyListeners();
  }

  void setSort(SortOrder order) {
    _sort = order;
    notifyListeners();
  }

  Future<void> add(Product product) async {
    final created = await _repo.create(product);
    _all = [..._all, created];
    notifyListeners();
  }

  Future<void> edit(Product product) async {
    final updated = await _repo.update(product);
    _all = _all.map((p) => p.id == updated.id ? updated : p).toList();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    _all = _all.where((p) => p.id != id).toList();
    notifyListeners();
  }
}

