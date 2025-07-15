import 'package:find_it/utils/screens/view_items_screen.dart';
import 'package:flutter/material.dart';

class IdentityCardItem extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String status;
  final String description;
  final String imageUrl;
  final String sourceName;
  final String sourceId;
  final String contactName;
  final String contactNumber;
  final String sourceProfileImageUrl;
  final bool isLost;

  const IdentityCardItem({
    Key? key,
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.sourceName,
    required this.sourceId,
    required this.contactName,
    required this.contactNumber,
    required this.sourceProfileImageUrl,
    required this.isLost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Bottom overlay with details
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: isDarkMode ? Colors.black.withOpacity(0.85) : Colors.black.withOpacity(0.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Status
                    Row(
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            color: isLost ? Colors.redAccent : Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // View Item button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewItemScreen(
                              id: id,
                              title: title, // Use the provided name
                              category: category, // Set the category
                              status: status, // Use the provided status
                              description: description, // Add a meaningful description
                              imageUrl: imageUrl, // Use the provided imageUrl
                              sourceName: sourceName, // Placeholder source name
                              sourceId: sourceId,
                              sourceProfileImageUrl: sourceProfileImageUrl, 
                              ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                        foregroundColor: isDarkMode ? Colors.white : Colors.black,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.25),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View Item',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
