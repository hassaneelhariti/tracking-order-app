import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:order_tracking/models/order_model.dart';
import 'package:order_tracking/widgets/tracking/tracking_info_card.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String trackingNumber;

  const OrderTrackingScreen({super.key, required this.trackingNumber});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late Future<OrderModel?> _orderFuture;
  final storage = const FlutterSecureStorage();
  bool? isSignedIn;

  @override
  void initState() {
    super.initState();
    _orderFuture = fetchOrder(widget.trackingNumber);
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await storage.read(key: 'jwt');
    setState(() {
      isSignedIn = token != null && token.isNotEmpty;
    });
  }

  Future<OrderModel?> fetchOrder(String trackingNumber) async {
    const String apiUrl =
        'https://api-codinafricav2.speedliv.com/api/shippings/apiGetShippingStatus';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'orderId': trackingNumber}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          return OrderModel.fromJson(jsonResponse);
        }
        throw Exception('API success = false');
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Widget _buildStepIcon(bool completed) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: completed ? Colors.teal : Colors.grey[300],
      child: completed
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildLine(bool completed) {
    return Container(
      width: 2,
      height: 80,
      color: completed ? Colors.teal : Colors.grey[300],
    );
  }

  Widget _buildStepLabel(
    String status,
    String? description,
    String? date,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? getColorFromStatus(status) : Colors.grey[600],
            ),
          ),
          if (description != null && description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          if (date != null && date.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildStepProgress(OrderModel order) {
    List<OrderHistory> timeline = [...order.history];

    // if (!timeline.any((h) => h.status.toLowerCase() == 'processed')) {
    //   timeline.add(
    //     OrderHistory(
    //       status: 'processed',
    //       statusDescription: order.statusDescription,
    //       comment: null,
    //       date: order.date,
    //     ),
    //   );
    // }

    // Sort by date descending (most recent first)
    timeline.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(timeline.length, (i) {
        final current = timeline[i];
        final isCompleted = true;
        final isActive = i == 0;

        final String formattedDate = DateFormat(
          'yyyy-MM-dd • HH:mm',
        ).format(current.date);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _buildStepIcon(isCompleted),
                if (i < timeline.length - 1) _buildLine(true),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepLabel(
                    current.status[0].toUpperCase() +
                        current.status.substring(1),
                    current.statusDescription,
                    formattedDate,
                    isActive,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Track Order',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        elevation: 0, // Add this line
      ),

      body: FutureBuilder<OrderModel?>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No order data available'));
          }

          final order = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TrackingInfoCard(order: order),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: buildStepProgress(order),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.support_agent, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Call Support",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/tracking-input',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(0, 48),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text(
                          "Track Another",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Color getColorFromStatus(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return Colors.teal;
    case 'processed':
      return const Color(0xFFFF9800);
    case 'paid':
      return Colors.blue;
    case 'shipped':
      return Colors.green;
    case 'prepared':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
