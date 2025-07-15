import 'package:find_it/widgets/recently_found_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/custom_bottom_navigation.dart';
import '/widgets/search_bar_widget.dart';
import '/widgets/quick_action_grid.dart';
import 'notification_screen.dart';

class FindItHomeScreen extends StatefulWidget {
  const FindItHomeScreen({super.key});

  @override
  _FindItHomeScreenState createState() => _FindItHomeScreenState();
}

class _FindItHomeScreenState extends State<FindItHomeScreen> {
  final supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() => isLoading = true);
    try {
      final response = await supabaseClient
          .from('posts')
          .select()
          .order('timestamp', ascending: false);

      setState(() {
        allItems = List<Map<String, dynamic>>.from(response);
        filteredItems = allItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading items: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
          child: SingleChildScrollView(  // Wrap your content in a SingleChildScrollView
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FindIt.',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Main content in scrollable area
                const SizedBox(height: 5),
                SearchBarWidget(onSearch: (String ) {  },),
                const QuickActionGrid(),
                const RecentlyFoundSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        onHomePressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        onAddPressed: () {
          Navigator.pushReplacementNamed(context, '/post_item_screen');
        },
        onMessagePressed: () {
          Navigator.pushReplacementNamed(context, '/message_screen');
        },
        onSettingsPressed: () {
          Navigator.pushReplacementNamed(context, '/settings_screen');
        },
      ),
    );
  }
}
