import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastUtils.init(context);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Demo mode: Allow test credentials to bypass backend
    if (email == 'demo@test.com' && password == 'demo123') {
      setState(() => _isLoading = false);
      if (mounted) {
        ToastUtils.showSuccess('Welcome! (Demo Mode)');
        // Create a mock authenticated state
        ref.read(authProvider.notifier).setDemoMode();
        context.go('/home');
      }
      return;
    }

    try {
      // Use AuthProvider to correctly update global state
      await ref.read(authProvider.notifier).login(email, password);

      // Get updated state
      final authState = ref.read(authProvider);

      debugPrint('✅ LOGIN SUCCESS - User: ${authState.user?.email}');

      if (!mounted) return;
      setState(() => _isLoading = false);

      // If 2FA is required, navigate to the corresponding screen
      if (authState.requires2FA || authState.errorCode == 'AUTH_2FA_REQUIRED') {
        debugPrint('🔐 2FA required after login - navigating to 2FA screen');
        ToastUtils.showInfo('Enter your authentication code');
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          context.push(
            '/login-2fa',
            extra: {
              'email': authState.pendingEmail ?? email,
              'password': password,
            },
          );
        }
        return;
      }

      // Login successful - verify email
      if (!authState.isEmailVerified) {
        debugPrint('📧 Email not verified, going to verify-email');
        ToastUtils.showInfo('Please verify your email');
        context.go('/verify-email');
      } else if (authState.isAuthenticated) {
        debugPrint('🏠 Going to home');
        ToastUtils.showSuccess('Welcome back!');
        context.go('/home');
      } else {
        // Unexpected case: not authenticated state
        debugPrint('⚠️ Login finished but auth state is not authenticated');
        ToastUtils.showError('Could not sign in. Please try again.');
      }
    } on DioException catch (e) {
      debugPrint('🔴 DioException caught: ${e.response?.statusCode}');
      debugPrint('🔴 Response data: ${e.response?.data}');

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Detectar si es 2FA requerido
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final code = data['code'] as String?;
        final message = data['message'] as String?;

        debugPrint('🔍 Error code: $code');
        debugPrint('🔍 Error message: $message');

        if (code == 'AUTH_2FA_REQUIRED') {
          debugPrint('🔐 2FA REQUIRED - Navigating to 2FA screen');
          ToastUtils.showInfo('Enter your authentication code');

          await Future.delayed(const Duration(milliseconds: 300));

          if (mounted) {
            context.push(
              '/login-2fa',
              extra: {'email': email, 'password': password},
            );
          }
          return;
        }

        // Other errors
        final errorMsg = message ?? 'Login error';
        debugPrint('❌ Other error: $errorMsg');
        ToastUtils.showError(errorMsg);
      } else {
        debugPrint('❌ Unknown error format');
        ToastUtils.showError('Login error');
      }
    } catch (e) {
      debugPrint('❌ Generic exception: $e');

      if (!mounted) return;
      setState(() => _isLoading = false);

      final errorMsg = e.toString().replaceAll('Exception: ', '');

      // Last chance: detect 2FA by message
      if (errorMsg.toLowerCase().contains('2fa') ||
          errorMsg.toLowerCase().contains('two-factor') ||
          errorMsg.toLowerCase().contains('authentication')) {
        debugPrint('🔐 2FA detected in error message');
        ToastUtils.showInfo('Enter your authentication code');

        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          context.push(
            '/login-2fa',
            extra: {'email': email, 'password': password},
          );
        }
      } else {
        ToastUtils.showError(errorMsg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    decoration: AppTheme.getInputDecoration(
                      context,
                      labelText: 'Email',
                      hintText: 'your@email.com',
                      prefixIcon: Icons.alternate_email,
                    ),
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
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                    decoration: AppTheme.getInputDecoration(
                      context,
                      labelText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppTheme.getSecondaryTextColor(context),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Demo credentials info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Demo Mode',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppTheme.getTextColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try the app without a backend:',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.getSecondaryTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Email: demo@test.com',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          'Password: demo123',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getSecondaryTextColor(context),
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => context.go('/register'),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
