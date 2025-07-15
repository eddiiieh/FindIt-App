import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/widgets/settings_menu_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> signOut(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      // Add these lines to clear SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userName');
      await prefs.remove('userProfileImageUrl');
      print("User details cleared from SharedPreferences");
      
      Navigator.pushReplacementNamed(context, '/signup_screen'); // Redirect to login
    } catch (e) {
      print("Sign-out failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                      child: Icon(Icons.arrow_back, size: 28, color: theme.iconTheme.color),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Section (Dynamic Name & Photo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      backgroundImage: user?.photoURL != null 
                          ? NetworkImage(user!.photoURL!)  // Use Google profile picture
                          : const AssetImage('assets/default_avatar.png') as ImageProvider, // Default image
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'Guest User',  // Use Google name or default
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            print("Navigating to Account Settings...");
                            Navigator.pushNamed(context, '/account_settings');
                          },
                          child: Text(
                            'Edit Profile >',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.55),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Preferences Section
              sectionTitle('Preferences', theme),
              SettingsMenuItem(
                iconData: Icons.person,
                title: 'Account Settings',
                showForwardIcon: true,
                onTap: () {
                  print("Navigating to Account Settings...");
                  Navigator.pushNamed(context, '/account_settings');
                },
              ),
              SettingsMenuItem(
                iconData: Icons.notifications,
                title: 'Notifications',
                showForwardIcon: true,
                onTap: () {
                  print("Navigating to Notifications Screen...");
                  Navigator.pushNamed(context, '/notifications_screen');
                },
              ),
              SettingsMenuItem(
                iconData: Icons.color_lens,
                title: 'Appearance',
                showForwardIcon: true,
                onTap: () {
                  print("Navigating to the Appearance Screen...");
                  Navigator.pushNamed(context, '/appearance_screen');
                },
              ),

              // Resources Section
              sectionTitle('Resources', theme),
              SettingsMenuItem(
                iconData: Icons.support,
                title: 'Contact support',
                showForwardIcon: true,
                onTap: () {
                  print("Navigating to Contacts Screen...");
                  Navigator.pushNamed(context, '/contacts_screen');
                },
              ),
              SettingsMenuItem(
                iconData: Icons.help,
                title: 'Help',
                showForwardIcon: true,
                onTap: () {
                  print("Navigating to the Help Screen...");
                  Navigator.pushNamed(context, '/help_screen');
                },
              ),
              SettingsMenuItem(
                iconData: Icons.star,
                title: 'Rate us on Google Play',
                showForwardIcon: true,
                onTap: () {},
              ),
              SettingsMenuItem(
                iconData: Icons.share,
                title: 'Follow us @findit',
                showForwardIcon: true,
                onTap: () {},
              ),

              const SizedBox(height: 15),

              // Sign Out Button (Now Functional)
              SettingsMenuItem(
                iconData: Icons.logout,
                title: 'Sign out',
                onTap: () => signOut(context),
              ),

              const SizedBox(height: 30),

              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'FindIt.',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Version 1.0',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.55),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '© 2025',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for section titles
  Widget sectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.55),
        ),
      ),
    );
  }
}
