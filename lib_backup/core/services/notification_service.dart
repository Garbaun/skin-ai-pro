import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    await _createChannels();
  }

  static Future<void> _createChannels() async {
    const AndroidNotificationChannel waterChannel = AndroidNotificationChannel(
      'water_reminder',
      'Water Reminder',
      description: 'Reminders for drinking water',
      importance: Importance.high,
    );

    const AndroidNotificationChannel analysisChannel = AndroidNotificationChannel(
      'analysis_reminder',
      'Analysis Reminder',
      description: 'Reminders for skin analysis',
      importance: Importance.high,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    await androidPlugin?.createNotificationChannel(waterChannel);
    await androidPlugin?.createNotificationChannel(analysisChannel);
  }

  static Future<void> scheduleWaterReminders({
    required int dailyGoal,
    required int intervalHours,
    required String startTime,
    required String endTime,
  }) async {
    // Cancel existing water reminders
    await _notifications.cancel(1000);
    await _notifications.cancel(1001);
    await _notifications.cancel(1002);
    await _notifications.cancel(1003);
    await _notifications.cancel(1004);
    await _notifications.cancel(1005);
    await _notifications.cancel(1006);
    await _notifications.cancel(1007);

    final now = DateTime.now();
    final startHour = int.parse(startTime.split(':')[0]);
    final endHour = int.parse(endTime.split(':')[0]);
    
    int reminderCount = 0;
    int notificationId = 1000;

    for (int hour = startHour; hour < endHour; hour += intervalHours) {
      if (reminderCount >= dailyGoal) break;

      final scheduledTime = DateTime(now.year, now.month, now.day, hour, 0);
      
      if (scheduledTime.isAfter(now)) {
        await _scheduleNotification(
          id: notificationId++,
          title: '💧 Su İçme Zamanı!',
          body: 'Cildiniz için su içmeyi unutmayın. Sağlıklı cilt için hidrasyon şart!',
          scheduledDate: scheduledTime,
          channelId: 'water_reminder',
        );
        reminderCount++;
      }
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String channelId,
  }) async {
    final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'water_reminder',
      'Water Reminder',
      channelDescription: 'Reminders for drinking water',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}