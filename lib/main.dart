import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/firebase_service.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/firebase_auth_providers.dart';
import 'core/providers/analysis_provider.dart';
import 'core/providers/products_provider.dart';
import 'core/providers/tracking_provider.dart';
import 'core/localization/app_localizations.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/analysis/presentation/screens/analysis_screen.dart';
import 'features/history/presentation/screens/history_screen.dart';
import 'features/tracking/presentation/screens/tracking_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService.instance.initialize();
  
  runApp(
    const ProviderScope(
      child: SkinAIApp(),
    ),
  );
}

class SkinAIApp extends ConsumerWidget {
  const SkinAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema ve dil durumlarını izle
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final authState = ref.watch(firebaseAuthProvider);

    return MaterialApp(
      title: 'Skin AI Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B73FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B73FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: authState.isAuthenticated 
          ? const MainScreen() 
          : const LoginScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Uygulama başlatıldığında gerekli verileri yükle
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      // Kullanıcı verilerini yükle
      ref.read(analysisProvider.notifier).loadAnalysisHistory(user.id);
      ref.read(productsProvider.notifier).generatePersonalizedRecommendations(
        userId: user.id,
        skinTypes: ['combination'], // Kullanıcının cilt tipi buraya gelecek
        concerns: ['dryness', 'pores'], // Kullanıcının cilt sorunları buraya gelecek
        sensitivityLevel: 0.3, // Kullanıcının hassasiyet düzeyi
      );
      ref.read(trackingProvider.notifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Su takip verisini izle
    final waterData = ref.watch(waterTrackingProvider);
    final waterPercentage = ref.watch(waterPercentageProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin AI Pro'),
        centerTitle: true,
        actions: [
          // Su takip göstergesi
          if (waterPercentage < 100)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          value: waterPercentage / 100,
                          strokeWidth: 2,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      const Icon(Icons.water_drop, size: 14, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Text('${waterPercentage.toInt()}%'),
                ],
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          AnalysisScreen(),
          HistoryScreen(),
          TrackingScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Stack(
              children: [
                const Icon(Icons.camera_alt_outlined),
                if (currentUser?.analysisCredits != null &&
                    currentUser!.analysisCredits > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        currentUser!.analysisCredits.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            selectedIcon: Stack(
              children: [
                const Icon(Icons.camera_alt),
                if (currentUser?.analysisCredits != null &&
                    currentUser!.analysisCredits > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        currentUser!.analysisCredits.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Analiz',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
          NavigationDestination(
            icon: Stack(
              children: [
                const Icon(Icons.insights_outlined),
                if (waterPercentage < 100)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${waterData.remainingAmount}ml',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            selectedIcon: Stack(
              children: [
                const Icon(Icons.insights),
                if (waterPercentage < 100)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${waterData.remainingAmount}ml',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Takip',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}