import 'package:find_it/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PersonalDetailsSection extends StatelessWidget {
  final String displayName;
  final String email;

  const PersonalDetailsSection({
    Key? key,
    required this.displayName,
    required this.email,
  }) : super(key: key);

  Widget _buildDetailRow(BuildContext context, String label, String value, String actionText) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle edit action
            },
            child: Text(
              actionText,
              style: TextStyle(
                color: isDarkMode ? Colors.blue[300] : AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERSONAL DETAILS',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow(context, 'Full Name', displayName, 'Edit'),
        _buildDetailRow(context, 'Email address', email, 'Edit'),
      ],
    );
  }
}
