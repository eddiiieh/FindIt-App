import 'package:find_it/utils/screens/categories_screen.dart';
import 'package:find_it/utils/screens/identity_card_screen.dart';
import 'package:flutter/material.dart';
import 'quick_action_item.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isSmallScreen = MediaQuery.of(context).size.width < 640;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: isDarkMode ? Colors.white : Colors.black, // Adapting text color
          ),
        ),
        const SizedBox(height: 22),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: isSmallScreen ? 20 : 34,
          mainAxisSpacing: isSmallScreen ? 20 : 34,
          children: [
            QuickActionItem(
              icon: Icons.badge,
              label: 'ID Cards',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen(category: 'ID Cards')),
                );
              },
            ),
            QuickActionItem(
              icon: Icons.description,
              label: 'Documents',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen(category: 'Documents')),
                );
              },
            ),
            QuickActionItem(
              icon: Icons.vpn_key,
              label: 'Keys',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen(category: 'Keys')),
                );
              },
            ),
            QuickActionItem(
              icon: Icons.devices,
              label: 'Electronics',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen(category: 'Electronics')),
                );
              },
            ),
            QuickActionItem(
              icon: Icons.person,
              label: 'Personal Items',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen(category: 'Personal Items')),
                );
              },
            ),
            QuickActionItem(
              icon: Icons.more_horiz,
              label: 'More items',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
