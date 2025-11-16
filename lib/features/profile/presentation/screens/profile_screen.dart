import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/app_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;
    final theme = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profil başlığı
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Kullanıcı bilgileri kartı
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.purple[700],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Kullanıcı adı
                      Text(
                        user?.name ?? 'Kullanıcı',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Email
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Üyelik durumu
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: user?.isPremium == true 
                              ? Colors.purple[100] 
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user?.isPremium == true ? 'Premium Üye' : 'Standart Üye',
                          style: TextStyle(
                            color: user?.isPremium == true 
                                ? Colors.purple[700] 
                                : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // İstatistikler
              const Text(
                'İstatistikler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.purple[400],
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${user?.analysisCredits ?? 0}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Kalan Kredi',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.analytics,
                              color: Colors.green[400],
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '15',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Toplam Analiz',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),

              // Ayarlar
              const Text(
                'Ayarlar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Tema ayarı
              Card(
                child: ListTile(
                  leading: Icon(
                    theme == AppTheme.dark ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.purple,
                  ),
                  title: const Text('Tema'),
                  subtitle: Text(_getThemeText(theme)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showThemeDialog(context, ref);
                  },
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Dil ayarı
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.language,
                    color: Colors.purple,
                  ),
                  title: const Text('Dil'),
                  subtitle: Text(_getLanguageText(language)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showLanguageDialog(context, ref);
                  },
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Bildirim ayarları
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.purple,
                  ),
                  title: const Text('Bildirimler'),
                  subtitle: const Text('Su hatırlatıcı ve rutin bildirimleri'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Bildirim ayarlarına git
                  },
                ),
              ),
              
              const SizedBox(height: 24),

              // Premium yükseltme
              if (user?.isPremium != true) ...[
                Card(
                  elevation: 4,
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Premium\'a Yükseltin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sınırsız analiz, gelişmiş raporlar ve özel ürün önerileri',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          text: 'Premium\'a Geç',
                          onPressed: () {
                            // Premium satın alma
                          },
                          type: ButtonType.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Çıkış yap
              AppButton(
                text: 'Çıkış Yap',
                onPressed: () async {
                  try {
                    await ref.read(authProvider.notifier).signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Çıkış hatası: ${e.toString()}')),
                      );
                    }
                  }
                },
                type: ButtonType.danger,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeText(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return 'Açık';
      case AppTheme.dark:
        return 'Koyu';
      case AppTheme.system:
        return 'Sistem';
    }
  }

  String _getLanguageText(AppLanguage language) {
    switch (language) {
      case AppLanguage.turkish:
        return 'Türkçe';
      case AppLanguage.english:
        return 'English';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tema Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppTheme.values.map((theme) {
            return RadioListTile<AppTheme>(
              title: Text(_getThemeText(theme)),
              value: theme,
              groupValue: ref.read(themeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeProvider.notifier).setTheme(value);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dil Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLanguage.values.map((language) {
            return RadioListTile<AppLanguage>(
              title: Text(_getLanguageText(language)),
              value: language,
              groupValue: ref.read(languageProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}