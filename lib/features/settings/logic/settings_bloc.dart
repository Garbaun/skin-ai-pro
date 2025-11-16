import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateNotifications>(_onUpdateNotifications);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdateWaterReminder>(_onUpdateWaterReminder);
    on<ClearCache>(_onClearCache);
    
    // Load settings on initialization
    add(const LoadSettings());
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      final language = prefs.getString('language') ?? 'tr';
      final waterReminderEnabled = prefs.getBool('water_reminder_enabled') ?? true;
      final waterReminderInterval = prefs.getInt('water_reminder_interval') ?? 60;
      
      emit(SettingsState(
        notificationsEnabled: notificationsEnabled,
        language: language,
        waterReminderEnabled: waterReminderEnabled,
        waterReminderInterval: waterReminderInterval,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateNotifications(
    UpdateNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', event.enabled);
      
      emit(state.copyWith(notificationsEnabled: event.enabled));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', event.language);
      
      emit(state.copyWith(language: event.language));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onUpdateWaterReminder(
    UpdateWaterReminder event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('water_reminder_enabled', event.enabled);
      await prefs.setInt('water_reminder_interval', event.interval);
      
      emit(state.copyWith(
        waterReminderEnabled: event.enabled,
        waterReminderInterval: event.interval,
      ));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear specific cache data
      await prefs.remove('temp_data');
      await prefs.remove('cached_images');
      
      emit(state.copyWith(cacheCleared: true));
      
      // Reset the flag after a delay
      Future.delayed(const Duration(seconds: 2), () {
        emit(state.copyWith(cacheCleared: false));
      });
    } catch (e) {
      // Handle error
    }
  }
}