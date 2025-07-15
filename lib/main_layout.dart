import 'package:flutter/material.dart';
import 'package:order_tracking/screens/home_screen.dart';
import 'package:order_tracking/screens/orders_screen.dart';
import 'package:order_tracking/screens/profile_screen.dart';
import 'package:order_tracking/screens/tracking_screen.dart';
import 'package:order_tracking/widgets/bottom_bar.dart';

class MainLayout extends StatefulWidget {
  
  const MainLayout({super.key});
  
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    OrdersScreen(),
    TrackingScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
