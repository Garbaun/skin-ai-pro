import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/analysis/screens/analysis_screen.dart';
import '../../features/analysis/screens/analysis_results_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/history/screens/history_detail_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/analysis',
        builder: (context, state) => const AnalysisScreen(),
      ),
      GoRoute(
        path: '/analysis-results',
        builder: (context, state) {
          final result = state.extra as AnalysisResult?;
          return const AnalysisResultsScreen();
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/history-detail',
        builder: (context, state) {
          return const HistoryDetailScreen();
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    
    // Error handler
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.uri.path}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
    
    // Redirect to login if not authenticated (you can add auth logic here)
    redirect: (context, state) {
      // Add authentication logic here
      // For now, let all routes be accessible
      return null;
    },
  );
  
  // Navigation helpers
  static void goHome(BuildContext context) => context.go('/home');
  static void goLogin(BuildContext context) => context.go('/login');
  static void goRegister(BuildContext context) => context.go('/register');
  static void goAnalysis(BuildContext context) => context.go('/analysis');
  static void goAnalysisResult(BuildContext context, Map<String, dynamic> result) => 
      context.go('/analysis/result', extra: result);
  static void goHistory(BuildContext context) => context.go('/history');
  static void goHistoryDetail(BuildContext context, String analysisId) => 
      context.go('/history/detail/$analysisId');
  static void goTracking(BuildContext context) => context.go('/tracking');
  static void goComparison(BuildContext context, String analysisId1, String analysisId2) => 
      context.go('/tracking/comparison', extra: {'id1': analysisId1, 'id2': analysisId2});
  static void goProducts(BuildContext context) => context.go('/products');
  static void goProductDetail(BuildContext context, String productId) => 
      context.go('/products/detail/$productId');
  static void goSettings(BuildContext context) => context.go('/settings');
  static void goHelp(BuildContext context) => context.go('/settings/help');
  static void goLegal(BuildContext context) => context.go('/settings/legal');
}