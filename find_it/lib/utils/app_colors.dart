import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFFE4DEE5);
  static const Color primary = Color(0xFF1A5339);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF1A5339);
  static const Color divider = Color(0xFF181717);
  static const Color searchBarBorder = Color(0xFF1A5339);
  static const Color searchIconColor = Color(0xFF49454F);
}

class AppTextStyles {
  static TextStyle userName = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle userStatus = GoogleFonts.poppins(
    fontSize: 9,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static TextStyle inputText = GoogleFonts.poppins(
    fontSize: 9,
    color: AppColors.textSecondary,
  );
}