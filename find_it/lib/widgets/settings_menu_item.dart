import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsMenuItem extends StatelessWidget {
  final IconData? iconData;
  final String? iconUrl;
  final String title;
  final bool showForwardIcon;
  final VoidCallback onTap;

  const SettingsMenuItem({
    Key? key,
    this.iconData,
    this.iconUrl,
    required this.title,
    this.showForwardIcon = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        print("Tapped on: $title");
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            if (iconData != null)
              Icon(iconData, size: 22, color: textColor)
            else if (iconUrl != null)
              Image.network(iconUrl!, width: 22, height: 20, color: textColor)
            else
              Icon(Icons.settings, size: 22, color: textColor),

            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (showForwardIcon)
              Icon(Icons.arrow_forward_ios, size: 16, color: textColor),
          ],
        ),
      ),
    );
  }
}
