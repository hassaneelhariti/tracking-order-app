import 'package:flutter/material.dart';
import 'package:order_tracking/models/order_model.dart';

class TrackingInfoCard extends StatelessWidget {
  final OrderModel order;

  const TrackingInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // shadow color with opacity
            spreadRadius: 1, // how much the shadow spreads
            blurRadius: 8, // softening effect
            offset: Offset(0, 1), // X and Y offset
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tracking Number",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),

              Text(
                order.trackingNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.status.statusText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: order.status.statusColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Text(
                      //   order.statusDescription,
                      //   style: const TextStyle(color: Colors.grey),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
          Flexible(
            child: Container(
              width: 80,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 162, 0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                order.shippingCompany,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
