part of 'settings_bloc.dart';

class SettingsState {
  final bool notificationsEnabled;
  final String language;
  final bool waterReminderEnabled;
  final int waterReminderInterval;
  final bool isLoading;
  final bool cacheCleared;

  const SettingsState({
    this.notificationsEnabled = true,
    this.language = 'tr',
    this.waterReminderEnabled = true,
    this.waterReminderInterval = 60,
    this.isLoading = true,
    this.cacheCleared = false,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    String? language,
    bool? waterReminderEnabled,
    int? waterReminderInterval,
    bool? isLoading,
    bool? cacheCleared,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      waterReminderEnabled: waterReminderEnabled ?? this.waterReminderEnabled,
      waterReminderInterval: waterReminderInterval ?? this.waterReminderInterval,
      isLoading: isLoading ?? this.isLoading,
      cacheCleared: cacheCleared ?? this.cacheCleared,
    );
  }
}