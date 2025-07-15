import 'package:flutter/material.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define colors based on theme
    final backgroundColor = isDarkMode ? theme.colorScheme.surface : const Color.fromARGB(255, 255, 255, 255);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width <= 640;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: textColor,
                      ),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: Text(
                      'Contact support',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 28 : 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'System',
                        color: textColor,
                      ),
                    ),
                  ),

                  // Contact information
                  Column(
                    children: [
                      // Email row
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              size: 20,
                              color: textColor,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'support@finditteam.com',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 16,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Phone row
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 20,
                            color: textColor,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '020-312110',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 16,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
