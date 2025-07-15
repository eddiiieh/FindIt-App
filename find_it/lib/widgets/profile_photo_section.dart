import 'package:flutter/material.dart';
import 'package:find_it/utils/app_colors.dart';

class ProfilePhotoSection extends StatelessWidget {
  final String? profileImageUrl;

  const ProfilePhotoSection({Key? key, this.profileImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            image: profileImageUrl != null
                ? DecorationImage(
                    image: NetworkImage(profileImageUrl!),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage('assets/default_profile.png'), // Fallback image
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // Handle edit photo
              },
              child: Text(
                'Edit photo',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                // Handle remove photo
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  color: isDarkMode ? Colors.red[300] : AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
