import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final DateTime date;
  final int items;
  final double price;
  final String estimated;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.price,
    required this.estimated,
    required this.status,
  });
}

enum OrderStatus { Delivered, InTransit, Processing, Shipped, Cancelled }

extension OrderStatusExtension on OrderStatus {
  String get statusText {
    switch (this) {
      case OrderStatus.Delivered:
        return "Delivered";
      case OrderStatus.InTransit:
        return "In Transit";
      case OrderStatus.Processing:
        return "Processing";
      case OrderStatus.Shipped:
        return "Shipped";
      case OrderStatus.Cancelled:
        return "Cancelled";
    }
  }

  Color get statusColor {
    switch (this) {
      case OrderStatus.Delivered:
        return Colors.teal;
      case OrderStatus.InTransit:
        return Colors.orange;
      case OrderStatus.Processing:
        return Colors.blue;
      case OrderStatus.Shipped:
        return Colors.green;
      case OrderStatus.Cancelled:
        return Colors.red;
    }
  }
}
