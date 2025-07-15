import 'package:find_it/utils/screens/identity_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/category_card.dart';
import '/widgets/custom_bottom_navigation.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 640;
    final horizontalPadding = isSmallScreen ? 20.0 : 31.0;

    final List<Map<String, dynamic>> categories = [
      {'name': 'ID Cards', 'icon': Icons.badge},
      {'name': 'Documents', 'icon': Icons.description},
      {'name': 'Electronics', 'icon': Icons.devices},
      {'name': 'Personal Items', 'icon': Icons.person},
      {'name': 'Keys', 'icon': Icons.vpn_key},
      {'name': 'Bags & Accessories', 'icon': Icons.shopping_bag},
      {'name': 'Sports gear', 'icon': Icons.sports_tennis},
      {'name': 'Other', 'icon': Icons.category},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      horizontalPadding / 2,
                      10.0 + MediaQuery.of(context).padding.top,
                      horizontalPadding,
                      0.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Text(
                    'All Categories',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 24.0 : 24.0,
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 0.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: isSmallScreen ? 20.0 : 40.0,
                      mainAxisSpacing: isSmallScreen ? 20.0 : 29.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        title: categories[index]['name'] ?? '',
                        icon: categories[index]['icon'] as IconData,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(category: categories[index]['name']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavigation(
              onHomePressed: () {
                Navigator.pushNamed(context, '/home');
              },
              onAddPressed: () {
                Navigator.pushNamed(context, '/post_item_screen');
              },
              onMessagePressed: () {
                Navigator.pushNamed(context, '/message_screen');
              },
              onSettingsPressed: () {
                Navigator.pushNamed(context, '/settings_screen');
              },
            ),
          ),
        ],
      ),
    );
  }
}
