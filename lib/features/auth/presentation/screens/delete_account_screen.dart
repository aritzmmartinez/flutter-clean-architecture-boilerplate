import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../../core/utils/toast_utils.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _confirmedRisks = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_confirmedRisks) {
      ToastUtils.showError(
          'You must confirm that you understand the consequences');
      return;
    }

    // Double confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are You Absolutely Sure?'),
        content: const Text(
          'This action is IRREVERSIBLE. All your data will be permanently '
          'deleted and cannot be recovered.',
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
            child: const Text('Yes, Delete My Account'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authProvider.notifier).deleteAccount(
            password: _passwordController.text,
            confirmation: _confirmationController.text,
          );

      if (mounted) {
        ToastUtils.showSuccess('Account deleted successfully');
        // User is automatically logged out by the provider
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(
          e.toString().replaceAll('Exception: ', ''),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final userEmail = authState.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.errorContainer,
        foregroundColor: theme.colorScheme.onErrorContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Danger icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      size: 48,
                      color: theme.colorScheme.onError,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Danger Zone',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'This action cannot be undone',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Warning box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By deleting your account:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildWarningItem(
                        '• All your portfolios will be deleted',
                        theme,
                      ),
                      _buildWarningItem(
                        '• All your transactions will be deleted',
                        theme,
                      ),
                      _buildWarningItem(
                        '• All your assets will be deleted',
                        theme,
                      ),
                      _buildWarningItem(
                        '• Your complete history will be deleted',
                        theme,
                      ),
                      _buildWarningItem(
                        '• This action is PERMANENT and IRREVERSIBLE',
                        theme,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Confirmation checkbox
                CheckboxListTile(
                  value: _confirmedRisks,
                  onChanged: (value) {
                    setState(() {
                      _confirmedRisks = value ?? false;
                    });
                  },
                  title: Text(
                    'I understand that this action is irreversible and all my data will be permanently deleted',
                    style: theme.textTheme.bodySmall,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: theme.colorScheme.error,
                ),
                const SizedBox(height: 24),

                // Confirmation text field
                Text(
                  'To confirm, type exactly:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    'DELETE MY ACCOUNT',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmationController,
                  decoration: InputDecoration(
                    labelText: 'Confirmation',
                    hintText: 'DELETE MY ACCOUNT',
                    prefixIcon: const Icon(Icons.warning_amber),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value != 'DELETE MY ACCOUNT') {
                      return 'Text does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                Text(
                  'Confirm your password:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Your current password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Email confirmation
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'The account $userEmail will be permanently deleted.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Delete button
                FilledButton(
                  onPressed: _isLoading ? null : _deleteAccount,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('DELETE MY ACCOUNT PERMANENTLY'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWarningItem(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}
