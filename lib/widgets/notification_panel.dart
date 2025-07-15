import 'package:flutter/material.dart';

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Notification box
            Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ORDER UPDATES",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  _buildOrderNotification(
                    status: "Delivered",
                    description: "Your order #ORD-2024-001 has been delivered.",
                    time: "2 hrs ago",
                    isNew: true,
                  ),
                  _buildOrderNotification(
                    status: "Shipped",
                    description: "Order #ORD-2024-001 is out for delivery.",
                    time: "5 hrs ago",
                    isNew: false,
                  ),
                  _buildOrderNotification(
                    status: "Processing",
                    description: "Order #ORD-2024-001 is being prepared.",
                    time: "Yesterday",
                    isNew: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

// 🧩 Custom Order Notification Item
Widget _buildOrderNotification({
  required String status,
  required String description,
  required String time,
  required bool isNew,
}) {
  IconData icon;
  Color color;

  switch (status.toLowerCase()) {
    case 'delivered':
      icon = Icons.check_circle;
      color = Colors.green;
      break;
    case 'shipped':
      icon = Icons.local_shipping;
      color = Colors.orange;
      break;
    case 'processing':
      icon = Icons.settings;
      color = Colors.blue;
      break;
    default:
      icon = Icons.info_outline;
      color = Colors.grey;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        SizedBox(width: 10),
        Expanded(child: Text(description, style: TextStyle(fontSize: 14))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isNew)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    ),
  );
}

// 🔺 Triangle Painter
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
