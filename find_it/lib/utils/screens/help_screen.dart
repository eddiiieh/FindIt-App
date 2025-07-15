import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    final backgroundColor = theme.colorScheme.background;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top:12.0),
          child: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 'Help' text moved outside AppBar to prevent overflow
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Help',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 20), // Prevents tight spacing

            InkWell(
              onTap: () {
                // Handle report problem tap
              },
              child: Row(
                children: [
                  Icon(Icons.report_problem, color: textColor, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Report a problem',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.help_outline, color: textColor, size: 30),
            Icon(Icons.contact_support, color: textColor, size: 30),
            Icon(Icons.info_outline, color: textColor, size: 30),
          ],
        ),
      ),
    );
  }
}
