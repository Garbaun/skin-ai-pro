import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Theme Events
abstract class ThemeEvent {}
class ToggleThemeEvent extends ThemeEvent {}

// Theme States
class ThemeState {
  final ThemeMode themeMode;
  
  ThemeState({required this.themeMode});
  
  factory ThemeState.initial() => ThemeState(themeMode: ThemeMode.system);
}

// Theme Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final newThemeMode = state.themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    emit(ThemeState(themeMode: newThemeMode));
  }
}