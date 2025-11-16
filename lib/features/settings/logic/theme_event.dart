part of 'theme_bloc.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class LoadThemeMode extends ThemeEvent {
  const LoadThemeMode();
}

class ToggleThemeMode extends ThemeEvent {
  const ToggleThemeMode();
}