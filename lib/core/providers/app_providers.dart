import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tema modelleri
enum AppTheme { light, dark, system }

enum AppLanguage { turkish, english }

// Tema provider'ı
class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('app_theme') ?? AppTheme.system.index;
    state = AppTheme.values[themeIndex];
  }

  Future<void> setTheme(AppTheme theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_theme', theme.index);
  }

  ThemeMode get themeMode {
    switch (state) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }
}

// Dil provider'ı
class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.turkish) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageIndex = prefs.getInt('app_language') ?? AppLanguage.turkish.index;
    state = AppLanguage.values[languageIndex];
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_language', language.index);
  }

  Locale get locale {
    switch (state) {
      case AppLanguage.turkish:
        return const Locale('tr');
      case AppLanguage.english:
        return const Locale('en');
    }
  }

  String get languageCode {
    return locale.languageCode;
  }
}

// Provider tanımlamaları
final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

// Tema mode provider'ı
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.read(themeProvider.notifier).themeMode;
});

// Dil locale provider'ı
final localeProvider = Provider<Locale>((ref) {
  return ref.read(languageProvider.notifier).locale;
});

// App state provider (tüm uygulama durumu için)
class AppStateNotifier extends StateNotifier<bool> {
  AppStateNotifier() : super(false) {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Uygulama başlatılırken yapılacak işlemler
    await Future.delayed(const Duration(milliseconds: 500));
    state = true; // Uygulama hazır
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, bool>((ref) {
  return AppStateNotifier();
});