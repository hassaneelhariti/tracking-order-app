import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:order_tracking/const.dart';
import 'package:order_tracking/models/order_model.dart';

class OrderService {
  static final storage = FlutterSecureStorage();

  Future<List<OrderModel>> getOrders() async {
    final token = await storage.read(key: 'jwt');
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch user orders');
    }
  }

  Future<bool> followOrder(OrderModel order) async {
    final token = await storage.read(key: 'jwt');
    if (token == null) throw Exception('No token found');
    print('JWT Token: $token');
    print("my order kooko : ${order.id}");
    print('Order trackingNumber: ${order.trackingNumber}');
    print('Order status: ${order.history.last.status}');
    print('Order statusDescription: ${order.history.last.statusDescription}');

    final latestStatus = order.history.isNotEmpty ? order.history.last : null;

    final response = await http.post(
      Uri.parse('$baseUrl/order'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'trackingNumber': order.trackingNumber,
        'status': latestStatus?.status ?? '',
        'statusDescription': latestStatus?.statusDescription ?? '',
        'history': order.history
            .map(
              (h) => {
                'status': h.status,
                'statusDescription': h.statusDescription,
                'comment': h.comment,
                'date': h.date.toIso8601String(),
              },
            )
            .toList(),
      }),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
