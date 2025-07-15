import 'package:find_it/widgets/recently_found_item.dart'; // Import your RecentlyFoundItem widget
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase client
import 'package:google_fonts/google_fonts.dart'; // Assuming you use Google Fonts

class RecentlyFoundSection extends StatefulWidget {
  const RecentlyFoundSection({Key? key}) : super(key: key);

  @override
  State<RecentlyFoundSection> createState() => RecentlyFoundSectionState();
}

class RecentlyFoundSectionState extends State<RecentlyFoundSection> {
  final supabaseClient = Supabase.instance.client; // Get Supabase client instance
  List<Map<String, dynamic>> _recentItems = []; // List to hold fetched items
  bool _isLoading = true; // Loading indicator
  String? _error; // To hold any error message

  @override
  void initState() {
    super.initState();
    _fetchRecentItems(); // Fetch data when the widget is initialized
  }

  Future<void> _fetchRecentItems() async {
    try {
      // Fetch recent posts, ordered by timestamp descending, limit to a few
      final response = await supabaseClient
          .from('posts')
          .select('*') // Select all columns you need for display and navigation
          .order('timestamp', ascending: false)
          .limit(5); // Display the top 5 most recent items

      // Supabase select returns List<Map<String, dynamic>> on success
      if (response != null && response is List) {
         setState(() {
          _recentItems = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      } else {
         // Handle unexpected response format
         setState(() {
            _error = 'Unexpected data format from Supabase';
            _isLoading = false;
          });
      }


    } on PostgrestException catch (e) {
       setState(() {
          _error = 'Database error: ${e.message}';
          _isLoading = false;
       });
       print('Supabase Postgrest Error fetching recent items: $e');
    } catch (e) {
      setState(() {
        _error = 'Failed to load recent items: ${e.toString()}';
        _isLoading = false;
      });
      print('Generic Error fetching recent items: $e'); // Log the error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 640;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : theme.scaffoldBackgroundColor,
        border: Border.all(color: isDarkMode ? Colors.white : Colors.black54),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(isSmallScreen ? 15 : 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align title to the start
        children: [
          Text(
            // You can change this title if you want to show only 'Found' or 'Lost'
            'Recently Posted Items', // More general title
            style: GoogleFonts.poppins( // Using Google Fonts as in your previous code
              fontSize: isSmallScreen ? 18 : 22,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          _buildContent(isSmallScreen, isDarkMode), // Use a helper to build content
        ],
      ),
    );
  }

  Widget _buildContent(bool isSmallScreen, bool isDarkMode) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    } else if (_error != null) {
      return Center(child: Text('Error: $_error')); // Show error message
    } else if (_recentItems.isEmpty) {
      return const Center(child: Text('No recent items posted yet.')); // Message for empty list
    } else {
      return Column(
        children: _recentItems.map((item) {
          // Extract data from the fetched item map
          final String title = item['title'] ?? 'No Title';
          final DateTime? timestamp = item['timestamp'] != null ? DateTime.parse(item['timestamp']) : null;
          final String date = timestamp != null ? 'Posted on: ${timestamp.day}/${timestamp.month}/${timestamp.year}' : 'Date unknown';
          final String category = item['category'] ?? 'Other'; // Use category for icon hint

          // Determine icon based on category
          IconData itemIcon = Icons.folder_open; // Default icon
          if (category == 'ID Cards') itemIcon = Icons.badge;
          else if (category == 'Documents') itemIcon = Icons.description;
          else if (category == 'Electronics') itemIcon = Icons.devices;
          else if (category == 'Keys') itemIcon = Icons.vpn_key;
          else if (category == 'Bags & Accessories') itemIcon = Icons.backpack;
          else if (category == 'Sports gear') itemIcon = Icons.sports_soccer;
          else if (category == 'Personal Items') itemIcon = Icons.person;
          else if (category == 'Other') itemIcon = Icons.category;

          return Padding(
            // Apply bottom padding only if it's not the last item
            padding: EdgeInsets.only(bottom: _recentItems.last == item ? 0 : (isSmallScreen ? 15 : 24)),
            child: RecentlyFoundItem(
              icon: itemIcon, // Use dynamic icon
              title: title, // Use dynamic title
              date: date, // Use dynamic date string
              arrowIcon: Icons.arrow_forward_ios, // Still using static arrow for now
              showBottomBorder: _recentItems.last != item, // Hide border for the last item
              itemData: item, // Pass the full item data for navigation
            ),
          );
        }).toList(),
      );
    }
  }
}