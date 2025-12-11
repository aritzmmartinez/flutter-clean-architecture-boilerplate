import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authProvider).user;
    final currentUsername = user?.username ?? '';
    final currentFullName = user?.fullName ?? '';

    // Check if anything changed
    if (_usernameController.text == currentUsername &&
        _fullNameController.text == currentFullName) {
      ToastUtils.showInfo('There are no changes to save');
      return;
    }

    setState(() => _isLoading = true);
    HapticUtils.medium();

    try {
      await ref
          .read(authProvider.notifier)
          .updateProfile(
            username: _usernameController.text != currentUsername
                ? _usernameController.text
                : null,
            fullName: _fullNameController.text != currentFullName
                ? _fullNameController.text
                : null,
          );

      if (mounted) {
        ToastUtils.showSuccess('Profile updated successfully');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showChangePasswordDialog() {
    // Navigate to change password screen
    context.push('/change-password');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit profile'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        iconTheme: IconThemeData(
          color: AppTheme.isDarkMode(context)
              ? Colors.white
              : AppTheme.darkTeal,
        ),
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(onPressed: _saveChanges, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'user_avatar',
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.limeGreen,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.limeGreen.withValues(
                            alpha: 0.2,
                          ),
                          child: Text(
                            (user?.username ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkTeal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.limeGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20),
                          color: AppTheme.darkTeal,
                          onPressed: () {
                            ToastUtils.showInfo('Change photo - Coming soon');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _SectionHeader(title: 'Personal Information'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _fullNameController,
                decoration: AppTheme.getInputDecoration(
                  context,
                  labelText: 'Full name',
                  hintText: 'John Doe',
                  prefixIcon: Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: AppTheme.getInputDecoration(
                  context,
                  labelText: 'Username',
                  hintText: 'user123',
                  prefixIcon: Icons.alternate_email,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length < 3) {
                    return 'Minimum 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              _SectionHeader(title: 'Contact'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: AppTheme.getInputDecoration(
                  context,
                  labelText: 'Email',
                  hintText: 'your@email.com',
                  prefixIcon: Icons.email_outlined,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Security
              _SectionHeader(title: 'Security'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.isDarkMode(context)
                      ? AppTheme.darkSurface
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.isDarkMode(context)
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade200,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.isDarkMode(context)
                          ? AppTheme.limeGreen.withValues(alpha: 0.2)
                          : AppTheme.limeGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: AppTheme.isDarkMode(context)
                          ? AppTheme.limeGreen
                          : AppTheme.darkTeal,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Change password',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text('Update your password'),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.getSecondaryTextColor(context),
                  ),
                  onTap: _showChangePasswordDialog,
                ),
              ),

              const SizedBox(height: 32),

              // Info adicional
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.isDarkMode(context)
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.isDarkMode(context)
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppTheme.getSecondaryTextColor(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Changes will be saved automatically when you press "Save"',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getSecondaryTextColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.getSecondaryTextColor(context),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileCard({required this.children});

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
      child: Column(children: children),
    );
  }
}
