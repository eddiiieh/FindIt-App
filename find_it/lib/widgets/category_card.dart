import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap; // Add onTap parameter

  const CategoryCard({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap, // Accept onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: theme.cardColor, // ✅ Adapts to light/dark mode
          border: Border.all(
            color: theme.dividerColor, // ✅ Matches dark mode
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: theme.iconTheme.color, // ✅ Adapts to dark mode
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color, // ✅ Adapts to dark mode
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
