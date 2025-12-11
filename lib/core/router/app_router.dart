import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/login_2fa_screen.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/activity_log_screen.dart';
import '../../features/auth/presentation/screens/sessions_screen.dart';
import '../../features/auth/presentation/screens/enable_2fa_screen.dart';
import '../../features/auth/presentation/screens/disable_2fa_screen.dart';
import '../../features/auth/presentation/screens/delete_account_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/screens/main_layout.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/notifications/presentation/screens/notification_settings_screen.dart';
import '../../features/settings/presentation/screens/app_preferences_screen.dart';
import '../../features/settings/presentation/screens/edit_profile_screen.dart';
import 'page_transitions.dart';

// Provider to access router from anywhere
final appRouterProvider = Provider<GoRouter>((ref) {
  return ref.watch(routerProvider);
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isSplash = state.matchedLocation == '/splash';
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/verify-email' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation.startsWith('/reset-password') ||
          state.matchedLocation.startsWith('/login-2fa');

      // Always allow splash screen
      if (isSplash) {
        return null;
      }

      // If not authenticated and not on auth route, redirect to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If authenticated but email not verified
      if (isAuthenticated && !authState.isEmailVerified) {
        // Only allow verify-email and logout
        if (state.matchedLocation != '/verify-email' &&
            state.matchedLocation != '/logout') {
          return '/verify-email';
        }
      }

      // If authenticated and on login/register route, go to home
      if (isAuthenticated &&
          authState.isEmailVerified &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/register')) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash - no transition
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => PageTransitions.none(
          child: const SplashScreen(),
          state: state,
        ),
      ),

      // Auth - smooth fade
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => PageTransitions.fade(
          child: const LoginScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => PageTransitions.fade(
          child: const RegisterScreen(),
          state: state,
        ),
      ),

      // Email Verification
      GoRoute(
        path: '/verify-email',
        pageBuilder: (context, state) {
          final code = state.uri.queryParameters['code'];
          return PageTransitions.slideUp(
            child: VerifyEmailScreen(prefilledCode: code),
            state: state,
          );
        },
      ),

      // Password Reset Flow
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const ForgotPasswordScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/reset-password',
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';
          final code = state.uri.queryParameters['code'];
          return PageTransitions.slideUp(
            child: ResetPasswordScreen(
              email: email,
              prefilledCode: code,
            ),
            state: state,
          );
        },
      ),

      // 2FA Login
      GoRoute(
        path: '/login-2fa',
        pageBuilder: (context, state) {
          final params = state.extra as Map<String, String>? ?? {};
          final email = params['email'] ?? '';
          final password = params['password'] ?? '';
          return PageTransitions.slideUp(
            child: Login2FAScreen(
              email: email,
              password: password,
            ),
            state: state,
          );
        },
      ),

      // Change Password
      GoRoute(
        path: '/change-password',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const ChangePasswordScreen(),
          state: state,
        ),
      ),

      // Home - smooth fade
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => PageTransitions.fade(
          child: const MainLayout(),
          state: state,
        ),
      ),

      // Settings - slide from bottom
      GoRoute(
        path: '/notifications/settings',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const NotificationSettingsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/settings/preferences',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const AppPreferencesScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/settings/profile',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const EditProfileScreen(),
          state: state,
        ),
      ),

      // Security & Account Management
      GoRoute(
        path: '/settings/activity-log',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const ActivityLogScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/settings/sessions',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const SessionsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/settings/enable-2fa',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const Enable2FAScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/settings/disable-2fa',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const Disable2FAScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/settings/delete-account',
        pageBuilder: (context, state) => PageTransitions.slideUp(
          child: const DeleteAccountScreen(),
          state: state,
        ),
      ),
    ],
  );
});
