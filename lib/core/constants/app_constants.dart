import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF3B82F6); // Blue-500
  static const Color primaryLight = Color(0xFF60A5FA); // Blue-400
  static const Color primaryDark = Color(0xFF1E40AF); // Blue-800
  
  // Secondary Colors
  static const Color secondary = Color(0xFFF59E0B); // Amber-500
  static const Color secondaryLight = Color(0xFFFCD34D); // Amber-400
  static const Color secondaryDark = Color(0xFFD97706); // Amber-700
  
  // Accent Colors
  static const Color accent = Color(0xFF10B981); // Emerald-500
  static const Color accentLight = Color(0xFF34D399); // Emerald-400
  static const Color accentDark = Color(0xFF059669); // Emerald-700
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Skin Analysis Specific Colors
  static const Color skinToneLight = Color(0xFFFEF3C7);
  static const Color skinToneMedium = Color(0xFFFDE68A);
  static const Color skinToneDark = Color(0xFFF59E0B);
  static const Color concernRed = Color(0xFFEF4444);
  static const Color concernOrange = Color(0xFFF97316);
  static const Color concernYellow = Color(0xFFEAB308);
  static const Color concernGreen = Color(0xFF22C55E);
  static const Color concernBlue = Color(0xFF3B82F6);
  static const Color concernPurple = Color(0xFF8B5CF6);
  
  // Medical/Clinical Colors
  static const Color medicalBlue = Color(0xFF2563EB);
  static const Color medicalGreen = Color(0xFF16A34A);
  static const Color medicalRed = Color(0xFFDC2626);
  static const Color medicalOrange = Color(0xFFEA580C);
  
  // AI/Technology Colors
  static const Color aiPurple = Color(0xFF7C3AED);
  static const Color aiBlue = Color(0xFF3B82F6);
  static const Color aiTeal = Color(0xFF14B8A6);
  static const Color aiGradientStart = Color(0xFF3B82F6);
  static const Color aiGradientEnd = Color(0xFF8B5CF6);
}

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );
  
  static const TextStyle heading5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );
  
  static const TextStyle heading6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodyExtraSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // Captions
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );
  
  // Overline
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 1.5,
  );
  
  // Medical/Clinical specific
  static const TextStyle medicalLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  static const TextStyle medicalValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );
  
  static const TextStyle medicalNote = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontStyle: FontStyle.italic,
  );
}

class AppSpacing {
  // Extra Small
  static const double xs = 4.0;
  
  // Small
  static const double sm = 8.0;
  
  // Medium
  static const double md = 16.0;
  
  // Large
  static const double lg = 24.0;
  
  // Extra Large
  static const double xl = 32.0;
  
  // Extra Extra Large
  static const double xxl = 48.0;
  
  // Triple Extra Large
  static const double xxxl = 64.0;
}

class AppBorderRadius {
  // Small
  static const BorderRadius sm = BorderRadius.all(Radius.circular(4.0));
  
  // Medium
  static const BorderRadius md = BorderRadius.all(Radius.circular(8.0));
  
  // Large
  static const BorderRadius lg = BorderRadius.all(Radius.circular(12.0));
  
  // Extra Large
  static const BorderRadius xl = BorderRadius.all(Radius.circular(16.0));
  
  // Extra Extra Large
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(24.0));
  
  // Circle
  static const BorderRadius circle = BorderRadius.all(Radius.circular(9999.0));
  
  // Card
  static const BorderRadius card = BorderRadius.all(Radius.circular(12.0));
  
  // Button
  static const BorderRadius button = BorderRadius.all(Radius.circular(8.0));
  
  // Input
  static const BorderRadius input = BorderRadius.all(Radius.circular(8.0));
  
  // Chip
  static const BorderRadius chip = BorderRadius.all(Radius.circular(16.0));
  
  // Avatar
  static const BorderRadius avatar = BorderRadius.all(Radius.circular(9999.0));
}

class AppShadows {
  // Small shadow
  static const BoxShadow sm = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 2,
    spreadRadius: 0,
    offset: Offset(0, 1),
  );
  
  // Medium shadow
  static const BoxShadow md = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );
  
  // Large shadow
  static const BoxShadow lg = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    spreadRadius: 0,
    offset: Offset(0, 4),
  );
  
  // Extra Large shadow
  static const BoxShadow xl = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    spreadRadius: 0,
    offset: Offset(0, 8),
  );
  
  // Card shadow
  static const BoxShadow card = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    spreadRadius: 0,
    offset: Offset(0, 4),
  );
  
  // Button shadow
  static const BoxShadow button = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );
  
  // Medical card shadow
  static const BoxShadow medicalCard = BoxShadow(
    color: Color(0x0D2563EB),
    blurRadius: 12,
    spreadRadius: 0,
    offset: Offset(0, 6),
  );
}

class AppGradients {
  // Primary gradient
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Secondary gradient
  static const LinearGradient secondary = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // AI gradient
  static const LinearGradient ai = LinearGradient(
    colors: [AppColors.aiBlue, AppColors.aiPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Medical gradient
  static const LinearGradient medical = LinearGradient(
    colors: [AppColors.medicalBlue, AppColors.medicalGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Skin tone gradient
  static const LinearGradient skinTone = LinearGradient(
    colors: [AppColors.skinToneLight, AppColors.skinToneMedium, AppColors.skinToneDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Success gradient
  static const LinearGradient success = LinearGradient(
    colors: [AppColors.success, AppColors.accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Warning gradient
  static const LinearGradient warning = LinearGradient(
    colors: [AppColors.warning, AppColors.concernOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Error gradient
  static const LinearGradient error = LinearGradient(
    colors: [AppColors.error, AppColors.concernRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppDurations {
  // Quick animations
  static const Duration quick = Duration(milliseconds: 150);
  
  // Standard animations
  static const Duration standard = Duration(milliseconds: 250);
  
  // Slow animations
  static const Duration slow = Duration(milliseconds: 350);
  
  // Page transitions
  static const Duration pageTransition = Duration(milliseconds: 300);
  
  // Modal animations
  static const Duration modal = Duration(milliseconds: 200);
  
  // Toast/snackbar animations
  static const Duration toast = Duration(milliseconds: 250);
  
  // Loading animations
  static const Duration loading = Duration(milliseconds: 1000);
  
  // Medical/Clinical specific
  static const Duration medicalScan = Duration(milliseconds: 2000);
  static const Duration analysisProcessing = Duration(milliseconds: 3000);
}

class AppBreakpoints {
  // Mobile
  static const double mobile = 480;
  
  // Tablet
  static const double tablet = 768;
  
  // Desktop
  static const double desktop = 1024;
  
  // Large desktop
  static const double largeDesktop = 1440;
  
  // Extra large desktop
  static const double extraLargeDesktop = 1920;
}