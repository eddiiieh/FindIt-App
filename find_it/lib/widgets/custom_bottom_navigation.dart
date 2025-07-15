import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onAddPressed;
  final VoidCallback onMessagePressed;
  final VoidCallback onSettingsPressed;

  const CustomBottomNavigation({
    Key? key,
    required this.onHomePressed,
    required this.onAddPressed,
    required this.onMessagePressed,
    required this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).scaffoldBackgroundColor, // ✅ Use 'color' instead of 'backgroundColor'
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 30),
            onPressed: onHomePressed,
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined, size: 30),
            onPressed: onAddPressed,
          ),
          IconButton(
            icon: const Icon(Icons.message, size: 30),
            onPressed: onMessagePressed,
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 30),
            onPressed: onSettingsPressed,
          ),
        ],
      ),
    );
  }
}
