import 'package:flutter/material.dart';
import 'package:order_tracking/models/order_model.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  order.status.statusText,
                  style: TextStyle(
                    color: order.status.statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date and items
            Text(
              _formatDate(order.date),
              style: const TextStyle(color: Colors.black54),
            ),
            Text(
              "${order.items} ${order.items == 1 ? "item" : "items"}",
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 8),

            // Price and Estimate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${order.price.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Est: ${order.estimated}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ],
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
