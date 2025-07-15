import 'package:flutter/material.dart';
import 'package:find_it/utils/screens/view_items_screen.dart'; // Import your ViewItemScreen

class RecentlyFoundItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final IconData arrowIcon;
  final bool showBottomBorder;
  final Map<String, dynamic> itemData; // Add this to receive the item data

  const RecentlyFoundItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.date,
    required this.arrowIcon,
    this.showBottomBorder = true,
    required this.itemData, // Make itemData required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Wrap the content in an InkWell for tap functionality
    return InkWell(
      onTap: () {
        // Navigate to the ViewItemScreen when the item is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            // Assuming ViewItemScreen takes the item data as a parameter
            // You might need to adjust how ViewItemScreen expects the data
            builder: (context) => ViewItemScreen(
              // Pass the individual fields or the whole map depending on ViewItemScreen's constructor
              title: itemData['title'] ?? '',
              category: itemData['category'] ?? '',
              status: itemData['status'] ?? '',
              description: itemData['description'] ?? '',
              imageUrl: itemData['image_url'] ?? '',
              sourceName: itemData['source_name'] ?? 'Unknown User',
              sourceId: itemData['user_id'], // Ensure this is the correct key for user ID
              sourceProfileImageUrl: itemData['source_profile_image_url'] ?? 'default_image_url',
              id: itemData['id'], // Ensure this is the correct key for item ID
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          border: showBottomBorder
              ? Border(bottom: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon, // This icon is now passed from the parent widget
              size: 40,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // This title is now passed from the parent widget
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    date, // This date string is now passed from the parent widget
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              arrowIcon, // This icon is now passed from the parent widget
              size: 15,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}