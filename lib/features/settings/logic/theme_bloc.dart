import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<LoadThemeMode>(_onLoadThemeMode);
    on<ToggleThemeMode>(_onToggleThemeMode);
    
    // Load saved theme mode on initialization
    add(const LoadThemeMode());
  }

  Future<void> _onLoadThemeMode(
    LoadThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt('theme_mode') ?? 0;
      final themeMode = ThemeMode.values[themeIndex];
      emit(ThemeState(themeMode));
    } catch (e) {
      emit(const ThemeState(ThemeMode.system));
    }
  }

  Future<void> _onToggleThemeMode(
    ToggleThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newThemeMode = _getNextThemeMode(state.themeMode);
      
      await prefs.setInt('theme_mode', newThemeMode.index);
      emit(ThemeState(newThemeMode));
    } catch (e) {
      emit(const ThemeState(ThemeMode.system));
    }
  }

  ThemeMode _getNextThemeMode(ThemeMode current) {
    switch (current) {
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
      case ThemeMode.system:
        return ThemeMode.light;
    }
  }
}