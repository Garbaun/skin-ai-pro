part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateNotifications extends SettingsEvent {
  final bool enabled;

  const UpdateNotifications(this.enabled);
}

class UpdateLanguage extends SettingsEvent {
  final String language;

  const UpdateLanguage(this.language);
}

class UpdateWaterReminder extends SettingsEvent {
  final bool enabled;
  final int interval;

  const UpdateWaterReminder(this.enabled, this.interval);
}

class ClearCache extends SettingsEvent {
  const ClearCache();
}