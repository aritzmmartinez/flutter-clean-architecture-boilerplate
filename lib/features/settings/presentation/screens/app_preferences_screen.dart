import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../providers/app_preferences_provider.dart';

class AppPreferencesScreen extends ConsumerWidget {
  const AppPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(appPreferencesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('App preferences'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        iconTheme: IconThemeData(
          color: AppTheme.isDarkMode(context)
              ? Colors.white
              : AppTheme.darkTeal,
        ),
        elevation: 0,
      ),
      body: preferencesAsync.when(
        data: (prefs) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'Appearance'),
              const SizedBox(height: 8),
              _PreferencesCard(
                child: Consumer(
                  builder: (context, ref, child) {
                    final themeModeAsync = ref.watch(appThemeModeProvider);
                    return themeModeAsync.when(
                      data: (themeMode) {
                        final IconData icon;
                        final String subtitle;

                        if (themeMode == ThemeModeEnum.system) {
                          icon = Icons.settings_suggest_rounded;
                          subtitle = 'System';
                        } else if (themeMode == ThemeModeEnum.dark) {
                          icon = Icons.dark_mode_rounded;
                          subtitle = 'Dark';
                        } else {
                          icon = Icons.light_mode_rounded;
                          subtitle = 'Light';
                        }

                        return _PreferenceSelector(
                          icon: icon,
                          title: 'Theme',
                          subtitle: subtitle,
                          onTap: () {
                            HapticUtils.light();
                            _showThemeDialog(context, ref, themeMode);
                          },
                        );
                      },
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              _SectionHeader(title: 'Regional'),
              const SizedBox(height: 8),
              _PreferencesCard(
                child: _PreferenceSelector(
                  icon: Icons.format_list_numbered_rounded,
                  title: 'Number format',
                  subtitle: _getNumberFormatLabel(prefs.numberFormat),
                  onTap: () =>
                      _showNumberFormatDialog(context, ref, prefs.numberFormat),
                ),
              ),
              const SizedBox(height: 8),
              _PreferencesCard(
                child: _PreferenceSelector(
                  icon: Icons.attach_money_rounded,
                  title: 'Default currency',
                  subtitle: prefs.defaultCurrency,
                  onTap: () =>
                      _showCurrencyDialog(context, ref, prefs.defaultCurrency),
                ),
              ),
              const SizedBox(height: 8),
              _PreferencesCard(
                child: _PreferenceSelector(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: _getLanguageLabel(prefs.language),
                  onTap: () {
                    ToastUtils.showInfo('Language selection - Coming soon');
                  },
                ),
              ),

              const SizedBox(height: 32),

              _SectionHeader(title: 'Behavior'),
              const SizedBox(height: 8),
              _PreferencesCard(
                child: _PreferenceSwitch(
                  icon: Icons.warning_rounded,
                  title: 'Confirm before delete',
                  subtitle: 'Show confirmation dialog',
                  value: prefs.confirmBeforeDelete,
                  onChanged: (value) async {
                    HapticUtils.light();
                    await ref
                        .read(appPreferencesProvider.notifier)
                        .setConfirmBeforeDelete(value);
                  },
                ),
              ),
              const SizedBox(height: 8),
              _PreferencesCard(
                child: _PreferenceSwitch(
                  icon: Icons.vibration_rounded,
                  title: 'Vibration',
                  subtitle: 'Haptic feedback',
                  value: prefs.enableHaptics,
                  onChanged: (value) async {
                    if (value) {
                      HapticUtils.medium();
                    }
                    await ref
                        .read(appPreferencesProvider.notifier)
                        .setEnableHaptics(value);
                  },
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _showResetDialog(context, ref),
                  icon: const Icon(Icons.restore_rounded),
                  label: const Text('Restore default values'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Error loading preferences',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(appPreferencesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNumberFormatLabel(String format) {
    switch (format) {
      case 'comma':
        return '1.000,00 (European)';
      case 'dot':
        return '1,000.00 (American)';
      default:
        return format;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeModeEnum currentMode,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeModeEnum>(
                title: const Row(
                  children: [
                    Icon(Icons.settings_suggest_rounded),
                    SizedBox(width: 12),
                    Text('System'),
                  ],
                ),
                subtitle: const Text('Follow device theme'),
                value: ThemeModeEnum.system,
                groupValue: currentMode,
                onChanged: (value) async {
                  if (value != null) {
                    await ref
                        .read(appThemeModeProvider.notifier)
                        .setTheme(value);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                    ToastUtils.showSuccess('Theme updated');
                  }
                },
              ),
              RadioListTile<ThemeModeEnum>(
                title: const Row(
                  children: [
                    Icon(Icons.light_mode_rounded),
                    SizedBox(width: 12),
                    Text('Light'),
                  ],
                ),
                subtitle: const Text('Always use light theme'),
                value: ThemeModeEnum.light,
                groupValue: currentMode,
                onChanged: (value) async {
                  if (value != null) {
                    await ref
                        .read(appThemeModeProvider.notifier)
                        .setTheme(value);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                    ToastUtils.showSuccess('Theme updated');
                  }
                },
              ),
              RadioListTile<ThemeModeEnum>(
                title: const Row(
                  children: [
                    Icon(Icons.dark_mode_rounded),
                    SizedBox(width: 12),
                    Text('Dark'),
                  ],
                ),
                subtitle: const Text('Always use dark theme'),
                value: ThemeModeEnum.dark,
                groupValue: currentMode,
                onChanged: (value) async {
                  if (value != null) {
                    await ref
                        .read(appThemeModeProvider.notifier)
                        .setTheme(value);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                    ToastUtils.showSuccess('Theme updated');
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getLanguageLabel(String lang) {
    switch (lang) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return lang;
    }
  }

  void _showNumberFormatDialog(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Number Format'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('1.000,00 (European)'),
                subtitle: const Text('Comma for decimals'),
                value: 'comma',
                groupValue: current,
                onChanged: (value) async {
                  if (value != null) {
                    await ref
                        .read(appPreferencesProvider.notifier)
                        .setNumberFormat(value);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                    ToastUtils.showSuccess('Format updated');
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('1,000.00 (American)'),
                subtitle: const Text('Dot for decimals'),
                value: 'dot',
                groupValue: current,
                onChanged: (value) async {
                  if (value != null) {
                    await ref
                        .read(appPreferencesProvider.notifier)
                        .setNumberFormat(value);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                    ToastUtils.showSuccess('Format updated');
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencyDialog(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    final currencies = [
      'EUR',
      'USD',
      'GBP',
      'JPY',
      'CHF',
      'CAD',
      'AUD',
      'CNY',
      'MXN',
      'BRL',
    ];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Default Currency'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return RadioListTile<String>(
                  title: Text(currency),
                  subtitle: Text(_getCurrencyName(currency)),
                  value: currency,
                  groupValue: current,
                  onChanged: (value) async {
                    if (value != null) {
                      await ref
                          .read(appPreferencesProvider.notifier)
                          .setDefaultCurrency(value);
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                      ToastUtils.showSuccess('Currency updated');
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getCurrencyName(String code) {
    final names = {
      'EUR': 'Euro',
      'USD': 'United States Dollar',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'CHF': 'Swiss Franc',
      'CAD': 'Canadian Dollar',
      'AUD': 'Australian Dollar',
      'CNY': 'Chinese Yuan',
      'MXN': 'Mexican Peso',
      'BRL': 'Brazilian Real',
    };
    return names[code] ?? code;
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.restore_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          title: const Text('Restore default values?'),
          content: const Text(
            'This will reset all app preferences to their original values.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                await ref
                    .read(appPreferencesProvider.notifier)
                    .resetToDefaults();
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                ToastUtils.showSuccess('Preferences restored');
              },
              child: const Text('Restore'),
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

class _PreferencesCard extends StatelessWidget {
  final Widget child;

  const _PreferencesCard({required this.child});

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

class _PreferenceSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceSwitch({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.getSecondaryTextColor(context),
              ),
            )
          : null,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _PreferenceSelector extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PreferenceSelector({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.getSecondaryTextColor(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.getSecondaryTextColor(context),
      ),
      onTap: onTap,
    );
  }
}
