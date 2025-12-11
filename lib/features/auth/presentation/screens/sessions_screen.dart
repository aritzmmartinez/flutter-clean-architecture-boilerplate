import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/session_model.dart';
import '../providers/auth_provider.dart';
import '../../../../core/utils/toast_utils.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  SessionsListModel? _sessions;
  bool _isLoading = true;
  String? _errorMessage;
  Set<String> _revokingSessions = {};

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final sessions = await authService.getSessions();

      if (mounted) {
        final currentSessionExists = sessions.sessions.any((s) => s.isCurrent);

        if (!currentSessionExists && sessions.sessions.isNotEmpty) {
          ToastUtils.showError(
            'Your session has been closed from another device',
          );
          await ref.read(authProvider.notifier).logout();
          return;
        }

        setState(() {
          _sessions = sessions;
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

  Future<void> _revokeSession(SessionModel session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: Text(
          session.isCurrent
              ? 'You are about to close your current session. The application will close.'
              : 'Sign out on ${session.deviceName ?? "this device"}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _revokingSessions.add(session.id);
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.revokeSession(sessionId: session.id);

      if (mounted) {
        ToastUtils.showSuccess('Session closed successfully');

        if (session.isCurrent) {
          await ref.read(authProvider.notifier).logout();
        } else {
          await _loadSessions();
        }
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(e.toString().replaceAll('Exception: ', ''));
        setState(() {
          _revokingSessions.remove(session.id);
        });
      }
    }
  }

  Future<void> _revokeAllSessions() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out All Sessions'),
        content: const Text(
          'This will sign you out on all your devices, including this one. '
          'You will need to sign in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(authProvider.notifier).logoutAll();
      if (mounted) {
        ToastUtils.showSuccess('Sessions closed successfully');
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  IconData _getDeviceIcon(String? deviceName) {
    if (deviceName == null) return Icons.devices;

    final device = deviceName.toLowerCase();
    if (device.contains('iphone') || device.contains('ios')) {
      return Icons.phone_iphone;
    } else if (device.contains('android')) {
      return Icons.phone_android;
    } else if (device.contains('windows') || device.contains('mac')) {
      return Icons.computer;
    } else if (device.contains('ipad') || device.contains('tablet')) {
      return Icons.tablet;
    }
    return Icons.devices;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Right now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Devices'),
        centerTitle: true,
        actions: [
          if (_sessions != null && _sessions!.sessions.length > 1)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _revokeAllSessions,
              tooltip: 'Sign out all sessions',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSessions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadSessions,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _sessions == null || _sessions!.sessions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.devices_other,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No active sessions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadSessions,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    16 + MediaQuery.of(context).padding.bottom,
                  ),
                  children: [
                    Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'These are the active sessions on your devices. '
                                'You can sign out on any device.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      '${_sessions!.total} ${_sessions!.total == 1 ? "active device" : "active devices"}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ..._sessions!.sessions.map((session) {
                      final isRevoking = _revokingSessions.contains(session.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: session.isCurrent
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              _getDeviceIcon(session.deviceName),
                              color: session.isCurrent
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  session.deviceName ?? 'Unknown Device',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (session.isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Current',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (session.ipAddress != null)
                                Text(
                                  'IP: ${session.ipAddress}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              Text(
                                'Last activity: ${session.lastActivityAt != null ? _formatDate(session.lastActivityAt!) : 'Unknown'}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Created: ${_formatDate(session.createdAt)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          trailing: isRevoking
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.logout,
                                    color: theme.colorScheme.error,
                                  ),
                                  onPressed: () => _revokeSession(session),
                                  tooltip: 'Sign out',
                                ),
                          isThreeLine: true,
                        ),
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}
