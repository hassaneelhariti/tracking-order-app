import 'package:flutter/material.dart';
import 'package:order_tracking/widgets/notification_panel.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () => showNotificationDialog(context),
        ),
      ],
    );
  }
}
