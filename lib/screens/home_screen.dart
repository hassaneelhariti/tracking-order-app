import 'package:flutter/material.dart';
import 'package:order_tracking/screens/orders_screen.dart';
import 'package:order_tracking/widgets/dashboard_overview.dart';
import 'package:order_tracking/widgets/header.dart';
import 'package:order_tracking/widgets/my_seacrh_bar.dart';
import '../models/order_model.dart';
import 'package:order_tracking/widgets/orders/order_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<OrderModel> allOrders = [
      OrderModel(
        id: "ORD-2024-001",
        date: DateTime(2024, 1, 15),
        items: 3,
        price: 89.99,
        estimated: "Delivered",
        status: OrderStatus.Delivered,
      ),
      OrderModel(
        id: "ORD-2024-002",
        date: DateTime(2024, 1, 18),
        items: 2,
        price: 156.50,
        estimated: "Jan 22, 2024",
        status: OrderStatus.InTransit,
      ),
      OrderModel(
        id: "ORD-2024-003",
        date: DateTime(2024, 1, 20),
        items: 1,
        price: 45.25,
        estimated: "Jan 25, 2024",
        status: OrderStatus.Processing,
      ),
      OrderModel(
        id: "ORD-2024-004",
        date: DateTime(2024, 1, 21),
        items: 4,
        price: 234.75,
        estimated: "Jan 24, 2024",
        status: OrderStatus.Shipped,
      ),
      OrderModel(
        id: "ORD-2024-005",
        date: DateTime(2024, 1, 22),
        items: 2,
        price: 67.80,
        estimated: "Cancelled",
        status: OrderStatus.Cancelled,
      ),
    ];
    final List<OrderModel> recentOrders = allOrders.take(4).toList();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(title: "Home"),
              const SizedBox(height: 20),
              const MySearchBar(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    const DashboardOverview(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Orders",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrdersScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentOrders.length,
                      itemBuilder: (context, index) {
                        final order = recentOrders[index];
                        return OrderTile(order: order);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
