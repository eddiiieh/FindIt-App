import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;
  final VoidCallback? onTap;

  const NotificationItem({
    required this.title,
    required this.description,
    required this.timestamp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          Text(timestamp, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      onTap: onTap,
    );
  }
}