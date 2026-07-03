import "dart:convert";
import "package:http/http.dart" as http;

import "../models/product.dart";
import "api_config.dart";

class ProductRepository {
  final http.Client _client;
  ProductRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchAll() async {
    final res = await _client.get(ApiConfig.products());
    if (res.statusCode != 200) {
      throw Exception("Failed to load products (${res.statusCode}).");
    }
    final list = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    return list.map(Product.fromJson).toList();
  }

  Future<Product> create(Product product) async {
    final res = await _client.post(
      ApiConfig.products(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception("Failed to create product (${res.statusCode}).");
    }
    return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Product> update(Product product) async {
    final res = await _client.put(
      ApiConfig.products("/${product.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to update product (${res.statusCode}).");
    }
    return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    final res = await _client.delete(ApiConfig.products("/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Failed to delete product (${res.statusCode}).");
    }
  }
}

