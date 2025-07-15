import 'package:flutter/material.dart';
import 'package:order_tracking/const.dart';
import 'package:order_tracking/widgets/header.dart';
import 'package:order_tracking/widgets/tracking/help_widget.dart';
import 'package:order_tracking/widgets/tracking/order_tracking_sheet.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _orderIdController = TextEditingController();
  bool _isTracking = false;

  void _trackOrder() {
    setState(() {
      _isTracking = true;
    });
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          OrderTrackingDialog(orderId: '456929'),
    ).whenComplete(() => setState(() => _isTracking = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Header(title: 'Track Order'),
                    SizedBox(height: 20),
                    OrderIdInputWidget(controller: _orderIdController),
                    SizedBox(height: 20),
                    TrackButtonWidget(
                      onPressed: _trackOrder,
                      isLoading: _isTracking,
                    ),
                    SizedBox(height: 20),
                    HelpWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget TrackButtonWidget({
    required void Function() onPressed,
    required bool isLoading,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: maincolor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Track Order',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
    );
  }

  Widget OrderIdInputWidget({required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          'Enter Your Order ID',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your order status by entering your order ID below',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 40),

        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'e.g. ORD-2024-001',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
              borderSide: BorderSide.none, // No visible border
            ),
            fillColor: Color.fromARGB(255, 241, 243, 245),
            filled: true, // This enables the fillColor
          ),
        ),
      ],
    );
  }
}
