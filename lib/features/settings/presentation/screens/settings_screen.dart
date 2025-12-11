import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Inicializar toast
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastUtils.init(context);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Account
            _SectionHeader(title: 'Account'),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: Icons.person_rounded,
                title: 'Edit Profile',
                subtitle: 'Personal information and password',
                onTap: () {
                  context.push('/settings/profile');
                },
              ),
            ),

            const SizedBox(height: 32),

            // Section: General
            _SectionHeader(title: 'General'),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: Icons.tune_rounded,
                title: 'App Preferences',
                subtitle: 'Theme, language and behavior',
                onTap: () {
                  context.push('/settings/preferences');
                },
              ),
            ),

            const SizedBox(height: 32),

            // Section: Security and Privacy
            _SectionHeader(title: 'Security and Privacy'),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: Icons.lock_reset,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {
                  context.push('/change-password');
                },
              ),
            ),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: user?.twoFactorEnabled == true
                    ? Icons.security
                    : Icons.security_outlined,
                title: 'Two-Factor Authentication',
                subtitle: user?.twoFactorEnabled == true
                    ? 'Enabled'
                    : 'Protect your account',
                trailing: user?.twoFactorEnabled == true
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  if (user?.twoFactorEnabled == true) {
                    context.push('/settings/disable-2fa');
                  } else {
                    context.push('/settings/enable-2fa');
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: Icons.devices_other,
                title: 'Active Devices',
                subtitle: 'Manage your sessions',
                onTap: () {
                  context.push('/settings/sessions');
                },
              ),
            ),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: Icons.history,
                title: 'Activity History',
                subtitle: 'Review recent actions',
                onTap: () {
                  context.push('/settings/activity-log');
                },
              ),
            ),

            const SizedBox(height: 32),

            // Section: Account Management
            _SectionHeader(title: 'Account Management'),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                subtitle: 'Log out of this device',
                onTap: () => _showLogoutDialog(context, ref),
              ),
            ),
            const SizedBox(height: 8),
            _SettingsCard(
              child: _SettingsTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete',
                iconColor: Theme.of(context).colorScheme.error,
                titleColor: Theme.of(context).colorScheme.error,
                onTap: () {
                  context.push('/settings/delete-account');
                },
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Investment Tracker',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getSecondaryTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getSecondaryTextColor(context),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.logout_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          title: const Text('Sign Out?'),
          content: const Text(
            'Are you sure you want to sign out on this device?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  ToastUtils.showSuccess('Session closed successfully');
                  context.go('/login');
                }
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppTheme.getSecondaryTextColor(context),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.isDarkMode(context)
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
  final bool showBadge;
  final int badgeCount;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? Theme.of(context).colorScheme.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          if (showBadge && badgeCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? '9+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.getSecondaryTextColor(context),
              ),
            )
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.getSecondaryTextColor(context),
                )
              : null),
      onTap: onTap,
    );
  }
}
