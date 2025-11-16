import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/app_localizations_extension.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(context, ref, l10n),
            const SizedBox(height: 24),
            
            // Preferences Section
            _buildPreferencesSection(context, ref, l10n, themeMode, language),
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildNotificationsSection(context, ref, l10n),
            const SizedBox(height: 24),
            
            // Support Section
            _buildSupportSection(context, l10n),
            const SizedBox(height: 24),
            
            // Account Section
            if (authState.isAuthenticated) ...[
              _buildAccountSection(context, ref, l10n),
              const SizedBox(height: 24),
            ],
            
            // App Info
            _buildAppInfoSection(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.accountSettings,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (user != null) ...[
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.name ?? l10n.myProfile),
                subtitle: Text(user.email),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to profile screen
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(l10n.changePassword),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to change password screen
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.login),
                title: Text(l10n.login),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to login screen
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeMode themeMode,
    AppLanguage language,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.themeSettings,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.palette),
              title: Text(l10n.darkMode),
              trailing: DropdownButton<ThemeMode>(
                value: themeMode,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.lightTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.darkTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.systemTheme),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.languageSettings),
              subtitle: Text(language == AppLanguage.turkish ? l10n.turkish : l10n.english),
              trailing: DropdownButton<AppLanguage>(
                value: language,
                items: [
                  DropdownMenuItem(
                    value: AppLanguage.english,
                    child: Text(l10n.english),
                  ),
                  DropdownMenuItem(
                    value: AppLanguage.turkish,
                    child: Text(l10n.turkish),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).setLanguage(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationSettings,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.pushNotifications),
              subtitle: Text(l10n.analysisNotifications),
              value: true,
              onChanged: (value) {
                // Toggle push notifications
              },
            ),
            const Divider(),
            SwitchListTile(
              title: Text(l10n.reminderNotifications),
              subtitle: Text(l10n.waterReminder),
              value: true,
              onChanged: (value) {
                // Toggle reminder notifications
              },
            ),
            const Divider(),
            SwitchListTile(
              title: Text(l10n.emailNotifications),
              value: false,
              onChanged: (value) {
                // Toggle email notifications
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.help,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(l10n.contactUs),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to contact us
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: Text(l10n.rateApp),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Rate app
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(l10n.shareApp),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Share app
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.termsOfService),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show terms of service
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.privacyPolicy),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dataSettings,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: Text(l10n.exportData),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Export data
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restore_outlined),
              title: Text(l10n.importData),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Import data
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.clear_all_outlined),
              title: Text(l10n.clearCache),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                // Clear cache
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.cacheCleared)),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text(l10n.deleteAccount, style: const TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: () {
                // Show delete account confirmation
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.deleteAccount),
                    content: Text('${l10n.deleteAccount} ${l10n.confirm}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          // Delete account
                          Navigator.pop(context);
                        },
                        child: Text(l10n.confirm, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show logout confirmation
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.logout),
                    content: Text(l10n.logoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).signOut();
                          Navigator.pop(context);
                        },
                        child: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.about,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.appVersion),
              subtitle: const Text('1.0.0'),
            ),
          ],
        ),
      ),
    );
  }
}