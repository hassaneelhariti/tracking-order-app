import 'package:flutter/material.dart';
import 'package:order_tracking/screens/home_screen.dart';
import 'package:order_tracking/screens/orders_screen.dart';
import 'package:order_tracking/screens/profile_screen.dart';
import 'package:order_tracking/screens/shared_ui.dart';
import 'package:order_tracking/screens/tracking_screen.dart';
import 'package:order_tracking/widgets/bottom_bar.dart';
import 'package:order_tracking/widgets/profile/guest_profile_screen.dart';

class MainLayout extends StatefulWidget {
  final int selectedIndex;

  const MainLayout({super.key, this.selectedIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;
  bool? isSignedIn;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final signedIn = await isUserSignedIn();
    setState(() {
      isSignedIn = signedIn;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn == null) {
      // Still checking auth status
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> screens = [
      const HomeScreen(),
      const OrdersScreen(),
      const TrackingScreen(),
      isSignedIn! ? const ProfileScreen() : const GuestProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
