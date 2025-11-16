import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Su içme hatırlatıcı ayarları
class WaterReminderSettings {
  final bool enabled;
  final int dailyGoal; // ml cinsinden
  final int glassSize; // ml cinsinden
  final List<int> reminderHours; // 24 saat formatında saatler
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String reminderMessage;

  WaterReminderSettings({
    this.enabled = true,
    this.dailyGoal = 2000, // 2 litre
    this.glassSize = 250, // 250ml bardak
    this.reminderHours = const [9, 12, 15, 18, 21], // 5 hatırlatıcı
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.reminderMessage = 'Su içme zamanı! 💧',
  });

  WaterReminderSettings copyWith({
    bool? enabled,
    int? dailyGoal,
    int? glassSize,
    List<int>? reminderHours,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? reminderMessage,
  }) {
    return WaterReminderSettings(
      enabled: enabled ?? this.enabled,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      glassSize: glassSize ?? this.glassSize,
      reminderHours: reminderHours ?? this.reminderHours,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      reminderMessage: reminderMessage ?? this.reminderMessage,
    );
  }
}

// Su içme kaydı
class WaterIntakeRecord {
  final String id;
  final DateTime timestamp;
  final int amount; // ml cinsinden
  final bool isReminder;
  final String? note;

  WaterIntakeRecord({
    required this.id,
    required this.timestamp,
    required this.amount,
    this.isReminder = false,
    this.note,
  });
}

// Günlük su takip verisi
class DailyWaterData {
  final DateTime date;
  final int totalIntake;
  final int goal;
  final List<WaterIntakeRecord> records;
  final double completionPercentage;

  DailyWaterData({
    required this.date,
    required this.totalIntake,
    required this.goal,
    required this.records,
  }) : completionPercentage = (totalIntake / goal * 100).clamp(0.0, 100.0);

  bool get isGoalReached => totalIntake >= goal;
  int get remainingAmount => (goal - totalIntake).clamp(0, goal);
}

// Cilt bakım takip verisi
class SkinCareRoutine {
  final String id;
  final String name;
  final String description;
  final List<String> steps;
  final List<String> products;
  final List<int> reminderHours;
  final bool enabled;
  final int duration; // dakika cinsinden

  SkinCareRoutine({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.products,
    required this.reminderHours,
    this.enabled = true,
    this.duration = 15,
  });
}

// Rutin tamamlama kaydı
class RoutineCompletionRecord {
  final String routineId;
  final DateTime timestamp;
  final bool completed;
  final int? actualDuration; // dakika cinsinden
  final String? notes;

  RoutineCompletionRecord({
    required this.routineId,
    required this.timestamp,
    required this.completed,
    this.actualDuration,
    this.notes,
  });
}

// Takip state modeli
class TrackingState {
  final WaterReminderSettings waterSettings;
  final List<WaterIntakeRecord> todayWaterRecords;
  final Map<DateTime, DailyWaterData> waterHistory;
  final List<SkinCareRoutine> skinCareRoutines;
  final List<RoutineCompletionRecord> routineCompletions;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastSync;

  TrackingState({
    required this.waterSettings,
    this.todayWaterRecords = const [],
    this.waterHistory = const {},
    this.skinCareRoutines = const [],
    this.routineCompletions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.lastSync,
  });

  TrackingState copyWith({
    WaterReminderSettings? waterSettings,
    List<WaterIntakeRecord>? todayWaterRecords,
    Map<DateTime, DailyWaterData>? waterHistory,
    List<SkinCareRoutine>? skinCareRoutines,
    List<RoutineCompletionRecord>? routineCompletions,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastSync,
  }) {
    return TrackingState(
      waterSettings: waterSettings ?? this.waterSettings,
      todayWaterRecords: todayWaterRecords ?? this.todayWaterRecords,
      waterHistory: waterHistory ?? this.waterHistory,
      skinCareRoutines: skinCareRoutines ?? this.skinCareRoutines,
      routineCompletions: routineCompletions ?? this.routineCompletions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  // Günlük su verisini hesapla
  DailyWaterData get todayWaterData {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return waterHistory[todayDate] ?? DailyWaterData(
      date: todayDate,
      totalIntake: todayWaterRecords.fold(0, (sum, record) => sum + record.amount),
      goal: waterSettings.dailyGoal,
      records: todayWaterRecords,
    );
  }

  // Bugünkü su içme yüzdesi
  double get todayWaterPercentage => todayWaterData.completionPercentage;

  // Hedefe ulaşıldı mı?
  bool get isWaterGoalReached => todayWaterData.isGoalReached;
}

// Takip provider'ı
class TrackingNotifier extends StateNotifier<TrackingState> {
  TrackingNotifier() : super(TrackingState(
    waterSettings: WaterReminderSettings(),
  )) {
    _initializeTracking();
  }

  // Takip verilerini başlat
  Future<void> _initializeTracking() async {
    try {
      state = state.copyWith(isLoading: true);

      // SharedPreferences'tan ayarları yükle
      final prefs = await SharedPreferences.getInstance();
      
      // Su hatırlatıcı ayarları
      final waterEnabled = prefs.getBool('water_reminder_enabled') ?? true;
      final dailyGoal = prefs.getInt('water_daily_goal') ?? 2000;
      final glassSize = prefs.getInt('water_glass_size') ?? 250;
      final soundEnabled = prefs.getBool('water_sound_enabled') ?? true;
      final vibrationEnabled = prefs.getBool('water_vibration_enabled') ?? true;
      final reminderMessage = prefs.getString('water_reminder_message') ?? 'Su içme zamanı! 💧';
      
      // Hatırlatıcı saatleri yükle
      final reminderHoursString = prefs.getString('water_reminder_hours') ?? '9,12,15,18,21';
      final reminderHours = reminderHoursString.split(',').map((h) => int.parse(h.trim())).toList();

      final waterSettings = WaterReminderSettings(
        enabled: waterEnabled,
        dailyGoal: dailyGoal,
        glassSize: glassSize,
        reminderHours: reminderHours,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
        reminderMessage: reminderMessage,
      );

      // Örnek cilt bakım rutinleri
      final skinCareRoutines = _generateSampleRoutines();

      state = state.copyWith(
        waterSettings: waterSettings,
        skinCareRoutines: skinCareRoutines,
        isLoading: false,
        lastSync: DateTime.now(),
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Takip verileri yüklenirken hata oluştu: $e',
      );
    }
  }

  // Örnek rutinler oluştur
  List<SkinCareRoutine> _generateSampleRoutines() {
    return [
      SkinCareRoutine(
        id: 'morning_routine',
        name: 'Sabah Rutini',
        description: 'Güne başlarken cildinizi canlandırın',
        steps: ['Temizleyici', 'Tonik', 'Serum', 'Nemlendirici', 'Güneş Koruması'],
        products: ['Cleanser', 'Toner', 'Serum', 'Moisturizer', 'Sunscreen'],
        reminderHours: [8, 9],
        duration: 10,
      ),
      SkinCareRoutine(
        id: 'evening_routine',
        name: 'Akşam Rutini',
        description: 'Günün yorgunluğunu cildinizden arındırın',
        steps: ['Makyaj Temizleyici', 'Temizleyici', 'Tonik', 'Serum', 'Nemlendirici'],
        products: ['Makeup Remover', 'Cleanser', 'Toner', 'Serum', 'Night Cream'],
        reminderHours: [20, 21, 22],
        duration: 15,
      ),
      SkinCareRoutine(
        id: 'weekly_mask',
        name: 'Haftalık Maske',
        description: 'Haftada bir kez detaylı bakım',
        steps: ['Temizleyici', 'Peeling', 'Maske', 'Serum', 'Nemlendirici'],
        products: ['Cleanser', 'Exfoliator', 'Mask', 'Serum', 'Moisturizer'],
        reminderHours: [19],
        duration: 20,
      ),
    ];
  }

  // Su içme kaydı ekle
  Future<void> addWaterIntake({
    required int amount,
    bool isReminder = false,
    String? note,
  }) async {
    try {
      final record = WaterIntakeRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        amount: amount,
        isReminder: isReminder,
        note: note,
      );

      final updatedRecords = [...state.todayWaterRecords, record];
      
      // Günlük veriyi güncelle
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final updatedHistory = Map<DateTime, DailyWaterData>.from(state.waterHistory);
      
      updatedHistory[todayDate] = DailyWaterData(
        date: todayDate,
        totalIntake: updatedRecords.fold(0, (sum, r) => sum + r.amount),
        goal: state.waterSettings.dailyGoal,
        records: updatedRecords,
      );

      state = state.copyWith(
        todayWaterRecords: updatedRecords,
        waterHistory: updatedHistory,
      );

      // SharedPreferences'a kaydet
      await _saveWaterRecords(updatedRecords);

    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Su kaydı eklenirken hata oluştu: $e',
      );
    }
  }

  // Su hatırlatıcı ayarlarını güncelle
  Future<void> updateWaterSettings(WaterReminderSettings newSettings) async {
    try {
      state = state.copyWith(waterSettings: newSettings);

      // SharedPreferences'a kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('water_reminder_enabled', newSettings.enabled);
      await prefs.setInt('water_daily_goal', newSettings.dailyGoal);
      await prefs.setInt('water_glass_size', newSettings.glassSize);
      await prefs.setBool('water_sound_enabled', newSettings.soundEnabled);
      await prefs.setBool('water_vibration_enabled', newSettings.vibrationEnabled);
      await prefs.setString('water_reminder_message', newSettings.reminderMessage);
      await prefs.setString('water_reminder_hours', newSettings.reminderHours.join(','));

    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Ayarlar güncellenirken hata oluştu: $e',
      );
    }
  }

  // Rutin tamamlama kaydı ekle
  Future<void> completeRoutine({
    required String routineId,
    required bool completed,
    int? actualDuration,
    String? notes,
  }) async {
    try {
      final record = RoutineCompletionRecord(
        routineId: routineId,
        timestamp: DateTime.now(),
        completed: completed,
        actualDuration: actualDuration,
        notes: notes,
      );

      state = state.copyWith(
        routineCompletions: [...state.routineCompletions, record],
      );

      // SharedPreferences'a kaydet
      await _saveRoutineCompletion(record);

    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Rutin kaydı eklenirken hata oluştu: $e',
      );
    }
  }

  // Günlük su içme verisini getir
  DailyWaterData? getWaterDataForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return state.waterHistory[normalizedDate];
  }

  // Haftalık su içme istatistiği
  Map<String, dynamic> getWeeklyWaterStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    int totalIntake = 0;
    int goalDays = 0;
    int completedDays = 0;
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final waterData = getWaterDataForDate(date);
      
      if (waterData != null) {
        totalIntake += waterData.totalIntake;
        goalDays++;
        if (waterData.isGoalReached) {
          completedDays++;
        }
      }
    }
    
    return {
      'totalIntake': totalIntake,
      'averageDaily': goalDays > 0 ? totalIntake / goalDays : 0,
      'goalCompletionRate': goalDays > 0 ? completedDays / goalDays * 100 : 0,
      'completedDays': completedDays,
      'totalDays': goalDays,
    };
  }

  // Su kayıtlarını kaydet
  Future<void> _saveWaterRecords(List<WaterIntakeRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = records.map((r) => {
      'id': r.id,
      'timestamp': r.timestamp.toIso8601String(),
      'amount': r.amount,
      'isReminder': r.isReminder,
      'note': r.note,
    }).toList();
    
    await prefs.setString('water_records', recordsJson.toString());
  }

  // Rutin tamamlamalarını kaydet
  Future<void> _saveRoutineCompletion(RoutineCompletionRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final completions = prefs.getStringList('routine_completions') ?? [];
    
    completions.add('${record.routineId}|${record.timestamp.toIso8601String()}|${record.completed}|${record.actualDuration ?? 0}|${record.notes ?? ""}');
    
    await prefs.setStringList('routine_completions', completions);
  }

  // Hata mesajını temizle
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // Günlük veriyi sıfırla (yeni gün)
  Future<void> resetDailyData() async {
    state = state.copyWith(todayWaterRecords: []);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('water_records');
  }
}

// Provider tanımlamaları
final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  return TrackingNotifier();
});

// Su takip verisi provider'ı
final waterTrackingProvider = Provider<DailyWaterData>((ref) {
  return ref.watch(trackingProvider).todayWaterData;
});

// Su içme yüzdesi provider'ı
final waterPercentageProvider = Provider<double>((ref) {
  return ref.watch(trackingProvider).todayWaterPercentage;
});

// Rutinler provider'ı
final skinCareRoutinesProvider = Provider<List<SkinCareRoutine>>((ref) {
  return ref.watch(trackingProvider).skinCareRoutines;
});

// Haftalık su istatistikleri provider'ı
final weeklyWaterStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return ref.watch(trackingProvider).getWeeklyWaterStats();
});