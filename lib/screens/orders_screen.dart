import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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
  static final storage = FlutterSecureStorage();

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

  late Future<List<OrderModel>> futureOrders;
  List<OrderModel> _allOrders = [];
  List<OrderModel> _filteredOrders = [];

  OrderStatus? selectedFilter;
  bool? isSignedIn;

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

  Future<void> _loadOrders() async {
    try {
      final orders = await getOrders();
      setState(() {
        _allOrders = orders;
        _applyFilterAndSearch();
      });
    } catch (e) {
      setState(() {
        _allOrders = [];
        _filteredOrders = [];
      });
    }
  }

  void _onSearchChanged() {
    _applyFilterAndSearch();
  }

  void _applyFilterAndSearch() {
    final query = _searchController.text.toLowerCase();

    List<OrderModel> tempList = List.from(_allOrders);

    // Apply filter chip
    if (selectedFilter != null) {
      tempList = tempList.where((o) => o.status == selectedFilter).toList();
    }

    // Apply search
    if (query.isNotEmpty) {
      tempList = tempList.where((order) {
        // Change 'orderNumber' to the property you want to search by
        return order.trackingNumber.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredOrders = tempList;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

              MySearchBar(
                controller: _searchController,
                onChanged: (_) => _applyFilterAndSearch(),
              ),

              const SizedBox(height: 16),

              if (isSignedIn == null)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (!isSignedIn!)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Asset 1.png', // Path to your image in the assets folder
                          width: 200,

                          // Optional: applies a color filter
                          fit: BoxFit
                              .cover, // Adjusts how the image fits in the given space
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            "Sign in to access your personalized Home.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(250, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.teal,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signin');
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(250, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 36,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _filterChip(null, "All (${_allOrders.length})"),
                            _filterChip(OrderStatus.Delivered, "Delivered"),
                            _filterChip(OrderStatus.Prepared, "Prepared"),
                            _filterChip(OrderStatus.Processed, "Processed"),
                            _filterChip(OrderStatus.Shipped, "Shipped"),
                            _filterChip(OrderStatus.Paid, "Paid"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _filteredOrders.isEmpty
                          ? const Expanded(
                              child: Center(child: Text("No orders found.")),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _filteredOrders.length,
                                itemBuilder: (context, index) {
                                  return OrderTile(
                                    order: _filteredOrders[index],
                                  );
                                },
                              ),
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
            _applyFilterAndSearch();
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
          side: const BorderSide(color: Color.fromARGB(255, 233, 236, 239)),
        ),
      ),
    );
  }
}
