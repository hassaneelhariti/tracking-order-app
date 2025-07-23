import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:order_tracking/const.dart';
import 'package:order_tracking/main_layout.dart';
import 'package:order_tracking/screens/shared_ui.dart';
import 'package:order_tracking/widgets/dashboard_overview.dart';
import 'package:order_tracking/widgets/header.dart';
import 'package:order_tracking/widgets/my_seacrh_bar.dart';
import 'package:order_tracking/widgets/orders/order_tile.dart';
import 'package:order_tracking/models/order_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final storage = FlutterSecureStorage();

  bool? isSignedIn;

  List<OrderModel> _allOrders = [];
  List<OrderModel> _filteredOrders = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
    _searchController.addListener(_onSearchChanged);
  }

  Future<bool> isUserSignedIn() async {
    final token = await storage.read(key: 'jwt');
    return token != null && token.isNotEmpty;
  }

  Future<void> checkAuthStatus() async {
    final signedIn = await isUserSignedIn();
    if (signedIn) {
      await _loadOrders();
    }
    setState(() {
      isSignedIn = signedIn;
    });
  }

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

  Future<void> _loadOrders() async {
    try {
      final orders = await getOrders();
      setState(() {
        _allOrders = orders;
        _filteredOrders = List.from(orders);
      });
    } catch (e) {
      setState(() {
        _allOrders = [];
        _filteredOrders = [];
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = List.from(_allOrders);
      } else {
        _filteredOrders = _allOrders.where((order) {
          // Change 'orderNumber' to the field you want to search on
          return order.trackingNumber.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn == null) {
      // Loading state while checking auth
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(title: "Home"),
              const SizedBox(height: 20),

              // Pass controller and optionally onChanged callback
              MySearchBar(controller: _searchController),

              const SizedBox(height: 20),

              if (!isSignedIn!)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          "Sign in to access your personalized Home.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signin');
                          },
                          child: const Text("Sign In"),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: _filteredOrders.isEmpty
                      ? const Center(child: Text('No orders found.'))
                      : ListView(
                          children: [
                            DashboardOverview(orders: _filteredOrders),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recent Orders",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MainLayout(selectedIndex: 1),
                                      ),
                                    );
                                  },
                                  child: const Text(
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
                              itemCount: _filteredOrders.length > 4
                                  ? 4
                                  : _filteredOrders.length,
                              itemBuilder: (context, index) {
                                return OrderTile(order: _filteredOrders[index]);
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
