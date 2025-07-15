import 'package:flutter/material.dart';
import 'package:order_tracking/const.dart';
import 'package:order_tracking/widgets/header.dart';
import 'package:order_tracking/widgets/my_seacrh_bar.dart';
import '../models/order_model.dart';
import 'package:order_tracking/widgets/orders/order_tile.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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

  OrderStatus? selectedFilter;

  @override
  Widget build(BuildContext context) {
    List<OrderModel> filteredOrders = selectedFilter == null
        ? allOrders
        : allOrders.where((order) => order.status == selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(title: "My Orders"),
              const SizedBox(height: 16),
              MySearchBar(),
              const SizedBox(height: 16),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _filterChip(null, "All (${allOrders.length})"),
                    _filterChip(OrderStatus.Delivered, "Delivered"),
                    _filterChip(OrderStatus.InTransit, "In Transit"),
                    _filterChip(OrderStatus.Processing, "Processing"),
                    _filterChip(OrderStatus.Shipped, "Shipped"),
                    _filterChip(OrderStatus.Cancelled, "Cancelled"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return OrderTile(order: filteredOrders[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(OrderStatus? status, String label) {
    bool isSelected = selectedFilter == status;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedFilter = status;
          });
        },
        selectedColor: maincolor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: const Color.fromARGB(255, 248, 249, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color.fromARGB(255, 233, 236, 239),
          ), // Modify radius here
        ),
      ),
    );
  }
}
