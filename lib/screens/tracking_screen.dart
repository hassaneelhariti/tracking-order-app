import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:order_tracking/const.dart';
import 'package:order_tracking/models/order_model.dart';
import 'package:order_tracking/widgets/header.dart';
import 'package:order_tracking/widgets/tracking/help_widget.dart';
import 'package:order_tracking/screens/order_tracking_screen.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _orderIdController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isTracking = false;

  // Replace this with your real API URL
  final String fetchOrderApiUrl =
      'https://api-codinafricav2.speedliv.com/api/shippings/apiGetShippingStatus';

  Future<OrderModel?> fetchOrder(String trackingNumber) async {
    try {
      final response = await http.post(
        Uri.parse(fetchOrderApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'orderId': trackingNumber}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          return OrderModel.fromJson(jsonResponse);
        } else {
          throw Exception('API returned success=false');
        }
      } else {
        throw Exception('Failed to fetch order: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch order error: $e');
      return null;
    }
  }

  Future<bool> followOrder(OrderModel order) async {
    final token = await storage.read(key: 'jwt');
    if (token == null) throw Exception('No token found');

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

    print('Backend response status: ${response.statusCode}');
    print('Backend response body: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 201;
  }

  void _trackOrder() async {
    final orderId = _orderIdController.text.trim();
    if (orderId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an Order ID')));
      return;
    }

    setState(() => _isTracking = true);

    try {
      final order = await fetchOrder(orderId);

      if (order == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order not found or API error')),
        );
        setState(() => _isTracking = false);
        return;
      }

      final success = await followOrder(order);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(trackingNumber: orderId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to track order. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isTracking = false);
    }
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Header(title: 'Track Order'),
                    const SizedBox(height: 20),
                    OrderIdInputWidget(controller: _orderIdController),
                    const SizedBox(height: 20),
                    TrackButtonWidget(
                      onPressed: _trackOrder,
                      isLoading: _isTracking,
                    ),
                    const SizedBox(height: 20),
                    HelpWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget TrackButtonWidget({
    required void Function() onPressed,
    required bool isLoading,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: maincolor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Track Order',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
    );
  }

  Widget OrderIdInputWidget({required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          'Enter Your Order ID',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your order status by entering your order ID below',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'e.g. ORD-2024-001',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            fillColor: const Color.fromARGB(255, 241, 243, 245),
            filled: true,
          ),
        ),
      ],
    );
  }
}
