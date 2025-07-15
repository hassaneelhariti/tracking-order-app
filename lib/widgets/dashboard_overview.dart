import 'package:flutter/material.dart';
import 'dashboard_card.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 249, 250),
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
            children: const [
              DashboardCard(
                title: "Total Orders",
                count: "24",
                color: Colors.teal,
              ),
              DashboardCard(
                title: "Delivered",
                count: "18",
                color: Colors.green,
              ),
              DashboardCard(
                title: "In Transit",
                count: "4",
                color: Colors.orange,
              ),
              DashboardCard(
                title: "Processing",
                count: "2",
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
