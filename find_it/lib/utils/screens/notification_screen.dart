import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:find_it/widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('notifications') ?? [];

    List<Map<String, dynamic>> allNotifications = saved.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    // --- Add logic to filter out old notifications ---
    final now = DateTime.now();
    // Define how old a notification can be (e.g., 7 days)
    final minimumTime = now.subtract(const Duration(days: 2)); // Keep notifications from the last 7 days

    List<Map<String, dynamic>> recentNotifications = [];
    List<String> notificationsToKeepInStorage = []; // List to save back to SharedPreferences

    for (var notification in allNotifications) {
      try {
        final timestampString = notification['timestamp'];
        // Ensure timestamp exists and is a string before parsing
        if (timestampString != null && timestampString is String) {
          final notificationTime = DateTime.parse(timestampString);
          // Check if the notification is newer than the minimum time threshold
          if (notificationTime.isAfter(minimumTime)) {
            recentNotifications.add(notification);
            // Also add the string representation back to the list to be saved
            notificationsToKeepInStorage.add(jsonEncode(notification));
          }
        } else {
           // Optional: Handle notifications without a valid timestamp if necessary
           // print('Skipping notification with invalid timestamp: $notification');
        }
      } catch (e) {
        // Handle potential errors during timestamp parsing
        print('Error parsing notification timestamp: $e for notification: $notification');
        // Discard notifications with invalid timestamp format
      }
    }
    // --- End filtering logic ---

    // Save the filtered list (only recent notifications) back to SharedPreferences
    await prefs.setStringList('notifications', notificationsToKeepInStorage);

    setState(() {
      // Display the recent notifications, reversed to show newest first
      notifications = recentNotifications.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and title
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, size: 28, color: theme.iconTheme.color),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Notifications',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),

            // Notifications list
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Text(
                        'No recent notifications', // Updated message
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (ctx, index) {
                        final notification = notifications[index];
                        // Ensure keys match what you store in SharedPreferences
                        return NotificationItem(
                          title: notification['title'] ?? 'No Title', // Provide default value
                          description: notification['body'] ?? 'No Description', // Provide default value
                          timestamp: _formatDate(notification['timestamp']),
                          onTap: () {
                            // Ensure item_id exists before navigating
                             if (notification['item_id'] != null) {
                                Navigator.pushNamed(
                                  context,
                                  '/item_detail',
                                  arguments: {'item_id': notification['item_id']},
                                );
                             } else {
                                // Handle case where item_id is missing if necessary
                                print('Notification item_id is missing: $notification');
                             }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic timestamp) { // Accept dynamic to handle potential null/non-string
    try {
      if (timestamp != null && timestamp is String) {
        return DateFormat('MMM d, h:mm a').format(DateTime.parse(timestamp));
      }
       return 'Date unknown'; // Return default if timestamp is not a valid string
    } catch (e) {
      print('Error formatting date: $e for timestamp: $timestamp');
      return 'Date error'; // Indicate error
    }
  }
}