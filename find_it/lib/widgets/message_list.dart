import 'package:flutter/material.dart';

class MessageListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final Color avatarColor;

  const MessageListItem({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Adaptive colors
    final Color primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final Color secondaryTextColor = isDarkMode ? Colors.grey[400]! : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 13),
          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          // Time
          Text(
            time,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
