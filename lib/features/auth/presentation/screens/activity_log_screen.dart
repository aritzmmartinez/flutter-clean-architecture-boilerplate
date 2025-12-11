import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/activity_log_model.dart';
import '../providers/auth_provider.dart';

class ActivityLogScreen extends ConsumerStatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  ConsumerState<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends ConsumerState<ActivityLogScreen> {
  ActivityLogListModel? _activityLog;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadActivityLog();
  }

  Future<void> _loadActivityLog() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final activityLog = await authService.getActivityLog(limit: 100);

      if (mounted) {
        setState(() {
          _activityLog = activityLog;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  IconData _getIconForAction(String action) {
    switch (action) {
      case 'login':
      case 'login_2fa':
        return Icons.login;
      case 'password_change':
      case 'password_reset':
        return Icons.lock_reset;
      case 'email_verified':
        return Icons.verified;
      case '2fa_enabled':
      case '2fa_disabled':
        return Icons.security;
      case 'profile_update':
        return Icons.person;
      case 'account_deleted':
        return Icons.delete_forever;
      case 'session_revoked':
        return Icons.devices_other;
      case 'account_locked':
        return Icons.lock;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForAction(String action, ThemeData theme) {
    switch (action) {
      case 'login':
      case 'login_2fa':
      case 'email_verified':
        return Colors.green;
      case 'password_change':
      case 'password_reset':
        return Colors.orange;
      case '2fa_enabled':
        return Colors.blue;
      case '2fa_disabled':
      case 'session_revoked':
        return Colors.amber;
      case 'account_locked':
      case 'account_deleted':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadActivityLog,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadActivityLog,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _activityLog == null || _activityLog!.activities.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recent activity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadActivityLog,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _activityLog!.activities.length,
                itemBuilder: (context, index) {
                  final activity = _activityLog!.activities[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getColorForAction(
                          activity.action,
                          theme,
                        ).withValues(alpha: 0.1),
                        child: Icon(
                          _getIconForAction(activity.action),
                          color: _getColorForAction(activity.action, theme),
                        ),
                      ),
                      title: Text(
                        activity.description,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(activity.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (activity.deviceName != null ||
                              activity.ipAddress != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (activity.deviceName != null) ...[
                                  Icon(
                                    Icons.devices,
                                    size: 14,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    activity.deviceName!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                                if (activity.ipAddress != null &&
                                    activity.deviceName != null)
                                  const Text(' • '),
                                if (activity.ipAddress != null) ...[
                                  Text(
                                    activity.ipAddress!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                      isThreeLine:
                          activity.deviceName != null ||
                          activity.ipAddress != null,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
