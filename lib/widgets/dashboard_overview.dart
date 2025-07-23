import 'package:flutter/material.dart';
import 'package:order_tracking/models/order_model.dart';
import 'dashboard_card.dart';

class DashboardOverview extends StatelessWidget {
  final List<OrderModel> orders;

  const DashboardOverview({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final total = orders.length;
    final delivered = orders
        .where((o) => o.status == OrderStatus.Delivered)
        .length;
    final inTransit = orders.where((o) => o.status == OrderStatus.Paid).length;
    final processing = orders
        .where((o) => o.status == OrderStatus.Processed)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 249, 250),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 150 / 92,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DashboardCard(
                title: "Total Orders",
                count: total.toString(),
                color: Colors.teal,
              ),
              DashboardCard(
                title: "Delivered",
                count: delivered.toString(),
                color: Colors.green,
              ),
              DashboardCard(
                title: "Paid",
                count: inTransit.toString(),
                color: Colors.orange,
              ),
              DashboardCard(
                title: "Processing",
                count: processing.toString(),
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
