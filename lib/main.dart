import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/dio_client.dart';
import 'core/di/injection_container.dart' as di;
import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await di.initializeDependencies();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize notification service
  final notificationService = di.sl<NotificationService>();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(ProviderScope(
    child: MyApp(notificationService: notificationService),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    // Configure failed authentication callback
    // Called when refresh token fails automatically
    DioClient.setOnAuthenticationFailed(() {
      // Clear authentication state in the provider
      ref.read(authProvider.notifier).clearAuthState();
    });

    // Listen to notification actions
    widget.notificationService.notificationActionStream.listen((payload) {
      _handleNotificationAction(payload);
    });
  }

  void _handleNotificationAction(String payload) {
    // Add small delay to ensure router is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        // Check if widget is still mounted
        if (!mounted) return;

        // Check if user is authenticated
        final authState = ref.read(authProvider);
        if (!authState.isAuthenticated) {
          debugPrint('⚠️ User not authenticated, cannot navigate');
          return;
        }

        debugPrint('🔔 Handling notification action: $payload');

        // Get current router
        final router = ref.read(routerProvider);

        // TODO: Implement your notification routing logic here
        // Example:
        // if (payload == 'some_action') {
        //   router.push('/some-route');
        // } else {
        //   router.push('/home');
        // }

        // Default navigation to home
        router.push('/home');
      } catch (e) {
        debugPrint('❌ Error handling notification action: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return themeMode.when(
      data: (mode) => MaterialApp.router(
        title: 'Investment Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: mode == ThemeModeEnum.dark
            ? ThemeMode.dark
            : mode == ThemeModeEnum.light
                ? ThemeMode.light
                : ThemeMode.system,
        // Localization
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: Scaffold(
          backgroundColor: AppTheme.darkBackground,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.limeGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    size: 40,
                    color: AppTheme.darkTeal,
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.limeGreen),
                ),
              ],
            ),
          ),
        ),
      ),
      error: (_, __) => MaterialApp.router(
        title: 'Investment Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: router,
      ),
    );
  }
}
