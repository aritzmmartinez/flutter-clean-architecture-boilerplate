import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/services/notification_service.dart';
import '../providers/notification_settings_provider.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize toast after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastUtils.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Error loading settings',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (settings) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Master Switch
              Card(
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
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: settings.enabled
                          ? [
                              AppTheme.limeGreen.withValues(alpha: 0.1),
                              AppTheme.mintGreen.withValues(alpha: 0.05),
                            ]
                          : [
                              theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.1),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SwitchListTile(
                    value: settings.enabled,
                    onChanged: (_) async {
                      await ref
                          .read(notificationSettingsProvider.notifier)
                          .toggleEnabled();
                      ToastUtils.showSuccess(
                        settings.enabled
                            ? 'Notifications disabled'
                            : 'Notifications enabled',
                      );
                    },
                    title: Row(
                      children: [
                        Icon(
                          settings.enabled
                              ? Icons.notifications_active
                              : Icons.notifications_off,
                          color: settings.enabled
                              ? AppTheme.limeGreen
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Enable notifications',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 36, top: 4),
                      child: Text(
                        settings.enabled
                            ? 'You will receive alerts about your portfolio'
                            : 'You will not receive any notifications',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getSecondaryTextColor(context),
                        ),
                      ),
                    ),
                    activeThumbColor: AppTheme.limeGreen,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Portfolio Alerts Section
              const _SectionHeader(
                title: 'Portfolio',
                icon: Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(height: 12),

              _SettingCard(
                enabled: settings.enabled,
                children: [
                  SwitchListTile(
                    value: settings.portfolioChanges,
                    onChanged: settings.enabled
                        ? (_) => ref
                              .read(notificationSettingsProvider.notifier)
                              .togglePortfolioChanges()
                        : null,
                    title: Text(
                      'Significant changes',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Alerts for important variations',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSecondaryTextColor(context),
                      ),
                    ),
                    activeThumbColor: AppTheme.limeGreen,
                  ),
                  if (settings.portfolioChanges)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Threshold: ${settings.portfolioChangeThreshold.toStringAsFixed(1)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.getSecondaryTextColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Slider(
                            value: settings.portfolioChangeThreshold,
                            min: 1.0,
                            max: 20.0,
                            divisions: 19,
                            label:
                                '${settings.portfolioChangeThreshold.toStringAsFixed(1)}%',
                            activeColor: AppTheme.limeGreen,
                            onChanged: settings.enabled
                                ? (value) => ref
                                      .read(
                                        notificationSettingsProvider.notifier,
                                      )
                                      .setPortfolioChangeThreshold(value)
                                : null,
                          ),
                          Text(
                            'We will notify you when your portfolio changes more than ${settings.portfolioChangeThreshold.toStringAsFixed(1)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.getSecondaryTextColor(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Prices and Assets Section
              const _SectionHeader(
                title: 'Prices and assets',
                icon: Icons.show_chart,
              ),
              const SizedBox(height: 12),

              _SettingCard(
                enabled: settings.enabled,
                children: [
                  SwitchListTile(
                    value: settings.priceTargets,
                    onChanged: settings.enabled
                        ? (_) => ref
                              .read(notificationSettingsProvider.notifier)
                              .togglePriceTargets()
                        : null,
                    title: Text(
                      'Target prices',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'When an asset reaches the set price',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSecondaryTextColor(context),
                      ),
                    ),
                    activeThumbColor: AppTheme.limeGreen,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Dividends Section
              const _SectionHeader(
                title: 'Dividends',
                icon: Icons.attach_money,
              ),
              const SizedBox(height: 12),

              _SettingCard(
                enabled: settings.enabled,
                children: [
                  SwitchListTile(
                    value: settings.upcomingDividends,
                    onChanged: settings.enabled
                        ? (_) => ref
                              .read(notificationSettingsProvider.notifier)
                              .toggleUpcomingDividends()
                        : null,
                    title: Text(
                      'Upcoming dividends',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Reminders for upcoming payments',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSecondaryTextColor(context),
                      ),
                    ),
                    activeThumbColor: AppTheme.limeGreen,
                  ),
                  if (settings.upcomingDividends)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notify ${settings.dividendDaysAdvance} days in advance',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.getSecondaryTextColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Slider(
                            value: settings.dividendDaysAdvance.toDouble(),
                            min: 1,
                            max: 30,
                            divisions: 29,
                            label: '${settings.dividendDaysAdvance} days',
                            activeColor: AppTheme.limeGreen,
                            onChanged: settings.enabled
                                ? (value) => ref
                                      .read(
                                        notificationSettingsProvider.notifier,
                                      )
                                      .setDividendDaysAdvance(value.round())
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Daily Summary Section
              const _SectionHeader(
                title: 'Daily summary',
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 12),

              _SettingCard(
                enabled: settings.enabled,
                children: [
                  SwitchListTile(
                    value: settings.dailySummary,
                    onChanged: settings.enabled
                        ? (_) => ref
                              .read(notificationSettingsProvider.notifier)
                              .toggleDailySummary()
                        : null,
                    title: Text(
                      'Daily summary',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Daily notification with portfolio status',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSecondaryTextColor(context),
                      ),
                    ),
                    activeThumbColor: AppTheme.limeGreen,
                  ),
                  if (settings.dailySummary) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.limeGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: AppTheme.limeGreen,
                        ),
                      ),
                      title: Text(
                        'Summary time',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        '${settings.dailySummaryHour.toString().padLeft(2, '0')}:${settings.dailySummaryMinute.toString().padLeft(2, '0')}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getSecondaryTextColor(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      enabled: settings.enabled,
                      onTap: settings.enabled
                          ? () => _showTimePicker(context, settings)
                          : null,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 32),

              // Action buttons
              Center(
                child: Column(
                  children: [
                    // Test notification button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          final notificationService = NotificationService();
                          await notificationService.showNotification(
                            id: 999,
                            title: 'Test notification',
                            body: 'Tap here to go to the summary',
                            payload: 'daily_summary',
                          );
                          ToastUtils.showSuccess(
                            'Test notification sent',
                          );
                        },
                        icon: const Icon(Icons.notifications_active),
                        label: const Text('Test notification'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Permissions button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await ref
                              .read(notificationSettingsProvider.notifier)
                              .requestPermissions();

                          final enabled = await ref
                              .read(notificationSettingsProvider.notifier)
                              .areNotificationsEnabled();

                          if (enabled) {
                            ToastUtils.showSuccess(
                              'Notification permissions granted',
                            );
                          } else {
                            ToastUtils.showWarning(
                              'Permissions were denied',
                            );
                          }
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('Request permissions'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notifications may require additional permissions from the operating system.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getSecondaryTextColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext pickerContext, settings) async {
    final time = await showTimePicker(
      context: pickerContext,
      initialTime: TimeOfDay(
        hour: settings.dailySummaryHour,
        minute: settings.dailySummaryMinute,
      ),
      builder: (builderContext, child) {
        return Theme(
          data: Theme.of(builderContext).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.limeGreen,
              onPrimary: AppTheme.darkTeal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null && mounted) {
      await ref
          .read(notificationSettingsProvider.notifier)
          .setDailySummaryTime(time.hour, time.minute);
      if (mounted) {
        ToastUtils.showSuccess('Time updated');
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

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

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.children, required this.enabled});

  final List<Widget> children;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Card(
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
        child: Column(children: children),
      ),
    );
  }
}
