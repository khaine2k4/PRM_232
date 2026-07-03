import "dart:convert";
import "package:http/http.dart" as http;

import "../models/order.dart";
import "api_config.dart";

class OrderRepository {
  final http.Client _client;
  OrderRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<ShopOrder> create(ShopOrder order) async {
    final res = await _client.post(
      ApiConfig.orders(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(order.toJson()),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception("Failed to place order (${res.statusCode}).");
    }
    return ShopOrder.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<ShopOrder>> fetchAll() async {
    final res = await _client.get(ApiConfig.orders());
    if (res.statusCode != 200) {
      throw Exception("Failed to load orders (${res.statusCode}).");
    }
    final list = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    return list.map(ShopOrder.fromJson).toList();
  }
}
