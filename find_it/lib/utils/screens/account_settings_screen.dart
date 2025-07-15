import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/profile_photo_section.dart';
import '/widgets/personal_details_section.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Get the logged-in user
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
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Account Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Photo Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ProfilePhotoSection(profileImageUrl: user?.photoURL),
              ),
              const SizedBox(height: 24),

              // Personal Details Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PersonalDetailsSection(
                  displayName: user?.displayName ?? "No Name",
                  email: user?.email ?? "No Email",
                ),
              ),
              const SizedBox(height: 28),

              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
