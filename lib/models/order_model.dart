import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final String trackingNumber;
  final DateTime date;
  final String statusDescription;
  final OrderStatus status;
  final List<OrderHistory> history; // Added history field

  OrderModel({
    required this.id,
    required this.trackingNumber,
    required this.date,
    required this.statusDescription,
    required this.status,
    required this.history, // Added to constructor
  });

  /// Create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return OrderModel(
      id: data['id']?.toString() ?? 'N/A',
      trackingNumber: data['trackingNumber'] ?? 'UNKNOWN',
      date: data['date'] != null
          ? DateTime.parse(data['date'])
          : DateTime.now(),
      statusDescription: data['statusDescription'] ?? '',
      status: _mapStatus(data['status']),
      history:
          (data['history'] as List?)
              ?.map(
                (item) => OrderHistory.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  /// Convert string status to enum
  static OrderStatus _mapStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'DELIVERED':
        return OrderStatus.Delivered;
      case 'PROCESSED':
        return OrderStatus.Processed;
      case 'PROCESSING':
        return OrderStatus.Shipped;
      case 'SHIPPED':
        return OrderStatus.Shipped;
      case 'PAID':
        return OrderStatus.Paid;
      case 'PREPARED':
        return OrderStatus.Prepared;
      default:
        return OrderStatus.Processed;
    }
  }

  /// Get the shipping company from tracking prefix
  String get shippingCompany {
    final prefix = trackingNumber.substring(0, 3).toUpperCase();
    switch (prefix) {
      case 'TRK':
        return 'TrackExpress';
      case 'DHL':
        return 'DHL Express';
      case 'UPS':
        return 'UPS';
      case 'FED':
        return 'FedEx';
      case 'AMZ':
        return 'Amazon Logistics';
      case 'COD':
        return 'Cash On delivery';
      default:
        return 'Unknown Courier';
    }
  }
}

/// Status enum
enum OrderStatus { Delivered, Prepared, Processed, Shipped, Paid }

/// Status text + color extension
extension OrderStatusExtension on OrderStatus {
  String get statusText {
    switch (this) {
      case OrderStatus.Delivered:
        return "Delivered";
      case OrderStatus.Prepared:
        return "prepared";
      case OrderStatus.Processed:
        return "Processed";
      case OrderStatus.Shipped:
        return "Shipped";
      case OrderStatus.Paid:
        return "paid";
    }
  }

  Color get statusColor {
    switch (this) {
      case OrderStatus.Delivered:
        return Colors.teal;
      case OrderStatus.Processed:
        return const Color(0xFFFF9800);
      case OrderStatus.Paid:
        return Colors.blue;
      case OrderStatus.Shipped:
        return Colors.green;
      case OrderStatus.Prepared:
        return Colors.red;
    }
  }
}

class OrderHistory {
  final String status;
  final String statusDescription;
  final String? comment;
  final DateTime date;

  OrderHistory({
    required this.status,
    required this.statusDescription,
    this.comment,
    required this.date,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      status: json['status'] as String,
      statusDescription: json['statusDescription'] as String,
      comment: json['comment'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
