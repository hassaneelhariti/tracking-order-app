import 'package:flutter/material.dart';
import 'package:order_tracking/models/order_model.dart';

class TimelineItem extends StatelessWidget {
  final OrderHistory history;
  final bool isFirst;
  final OrderStatus overallStatus;

  const TimelineItem({
    super.key,
    required this.history,
    required this.isFirst,
    required this.overallStatus,
  });

  bool _isCompleted() {
    // If overall status is Delivered, mark all except "Paid" as completed
    if (overallStatus == OrderStatus.Delivered &&
        history.status.toLowerCase() != 'paid') {
      return true;
    }

    // Otherwise, mark only the current step (first) as completed
    return isFirst;
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.blue;
      case 'prepared':
        return Colors.orange;
      case 'delivered':
        return Colors.teal;
      case 'paid':
        return Colors.grey; // paid is always grey
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = _isCompleted();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.circle,
              color: completed ? Colors.green : Colors.grey,
              size: 20,
            ),
            Container(height: 40, width: 2, color: Colors.grey.shade400),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${history.date.year}-${history.date.month.toString().padLeft(2, '0')}-${history.date.day.toString().padLeft(2, '0')} ${history.date.hour}:${history.date.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(history.statusDescription),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(history.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    history.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
