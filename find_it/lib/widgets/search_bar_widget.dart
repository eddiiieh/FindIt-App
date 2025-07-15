import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String placeholder;
  final Function(String) onSearch;

  const SearchBarWidget({
    Key? key,
    this.placeholder = "Search for lost and found items",
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : theme.scaffoldBackgroundColor,
        border: Border.all(color: isDarkMode ? Colors.white : Colors.black),
        borderRadius: BorderRadius.circular(75),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: TextField(
        cursorColor: isDarkMode ? Colors.white : Colors.black,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onChanged: onSearch, // Call search function on input change
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white70 : Colors.black,
            fontFamily: 'Poppins',
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.search,
              color: isDarkMode ? Colors.white70 : Colors.black,
              size: 24,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
          ),
        ),
      ),
    );
  }
}
