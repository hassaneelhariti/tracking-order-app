import 'package:flutter/material.dart';
import 'package:order_tracking/models/order_model.dart';
import 'package:order_tracking/screens/order_tracking_screen.dart';
import 'package:order_tracking/screens/tracking_screen.dart'
    hide OrderTrackingScreen; // Replace with your actual screen

class OrderTile extends StatelessWidget {
  final OrderModel order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderTrackingScreen(trackingNumber: order.trackingNumber),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: ID and status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.trackingNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order.status.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status.statusText,
                      style: TextStyle(
                        color: order.status.statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Text(
                _formatDate(order.date),
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),

              // Shipping company
              Text(
                "Shipping via: ${order.shippingCompany}",
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${_pad(date.month)}-${_pad(date.day)}";
  }

  String _pad(int value) {
    return value < 10 ? '0$value' : value.toString();
  }
}
