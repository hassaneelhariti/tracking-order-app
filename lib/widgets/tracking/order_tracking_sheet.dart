import 'package:flutter/material.dart';
import 'package:order_tracking/const.dart';

class OrderTrackingDialog extends StatefulWidget {
  final String orderId;

  const OrderTrackingDialog({required this.orderId, super.key});

  @override
  State<OrderTrackingDialog> createState() => _OrderTrackingDialogState();
}

class _OrderTrackingDialogState extends State<OrderTrackingDialog> {
  final List<String> steps = ['pending', 'processing', 'shipped', 'completed'];

  String currentStatus = 'processing';
  // will be fetched from API
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7, // 70% screen height
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Order Tracking',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '#${widget.orderId}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Order Info Row
                _drawDateInfo('Fri, Dec 1, 2017', 'Sun, Dec 3 2017'),

                SizedBox(height: 20),

                // Status
                Text(
                  'Order Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                buildStepProgress(currentStatus),

                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(steps[0]),
                    Text(steps[1]),
                    Text(steps[2]),
                    Text(steps[3]),
                  ],
                ),

                SizedBox(height: 30),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // handle tracking
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maincolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Tracking Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIcon(bool completed) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: completed ? maincolor : Colors.grey[300],
      child: completed
          ? Icon(Icons.check, size: 16, color: Colors.white)
          : SizedBox.shrink(),
    );
  }

  Widget _buildLine(bool completed) {
    return Expanded(
      child: Container(
        height: 2,
        color: completed ? maincolor : Colors.grey[300],
      ),
    );
  }

  Widget buildStepProgress(String currentStatus) {
    final int currentIndex = steps.indexOf(currentStatus);

    List<Widget> widgets = [];

    for (int i = 0; i < steps.length; i++) {
      bool isCompleted = i <= currentIndex;

      // Add line before the icon except for the first step
      if (i != 0) {
        bool lineCompleted = i <= currentIndex;
        widgets.add(_buildLine(lineCompleted));
      }

      widgets.add(_buildStepIcon(isCompleted));
    }

    return Row(children: widgets);
  }

  Widget _drawDateInfo(String purchaseddate, String estimateddate) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Date Purchased',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(purchaseddate), //  hna  API data
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Estimated Delivery',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(estimateddate), // <-- hna API data
            ],
          ),
        ],
      ),
    );
  }
}
