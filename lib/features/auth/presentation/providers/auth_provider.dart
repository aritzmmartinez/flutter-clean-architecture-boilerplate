import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/auth_error_codes.dart';
import '../../data/services/auth_service.dart';

part 'auth_provider.g.dart';

 class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final String? errorCode;
  final bool isAuthenticated;
  final bool isInitialized;
  final bool requires2FA; 
  final String? pendingEmail;
  final bool isAccountLocked;
  final DateTime? lockedUntil;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.errorCode,
    this.isAuthenticated = false,
    this.isInitialized = false,
    this.requires2FA = false,
    this.pendingEmail,
    this.isAccountLocked = false,
    this.lockedUntil,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    String? errorCode,
    bool? isAuthenticated,
    bool? isInitialized,
    bool? requires2FA,
    String? pendingEmail,
    bool? isAccountLocked,
    DateTime? lockedUntil,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      errorCode: errorCode,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialized: isInitialized ?? this.isInitialized,
      requires2FA: requires2FA ?? this.requires2FA,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      isAccountLocked: isAccountLocked ?? this.isAccountLocked,
      lockedUntil: lockedUntil ?? this.lockedUntil,
    );
  }

   bool get isEmailVerified => user?.isVerified ?? false;

   bool get is2FAEnabled => user?.twoFactorEnabled ?? false;
}

 @riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

 @riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
     _checkAuthStatus();
    return const AuthState();
  }

   Future<void> _checkAuthStatus() async {
    final authService = ref.read(authServiceProvider);
    final isAuth = await authService.isAuthenticated();

    if (isAuth) {
      try {
        final user = await authService.getCurrentUser();
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isInitialized: true,
        );
      } catch (e) {
         state = state.copyWith(isAuthenticated: false, isInitialized: true);
      }
    } else {
       state = state.copyWith(isAuthenticated: false, isInitialized: true);
    }
  }

   Future<void> login(String email, String password) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      errorCode: null,
      requires2FA: false,
      isAccountLocked: false,
    );

    try {
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
        error: null,
        errorCode: null,
      );
    } on String catch (errorMessage) {
       state = state.copyWith(
        error: errorMessage,
        isLoading: false,
        isAuthenticated: false,
      );
      rethrow;
    } catch (e) {
       String errorMessage = e.toString().replaceAll('Exception: ', '');
      String? errorCode;

      debugPrint('🔍 Login catch block - Error type: ${e.runtimeType}');
      debugPrint('🔍 Error message: $errorMessage');

       if (e is DioException) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('code')) {
          errorCode = data['code'] as String;

           if (errorCode == AuthErrorCodes.twoFactorRequired) {
             state = state.copyWith(
              error: null,
              errorCode: AuthErrorCodes.twoFactorRequired,
              isLoading: false,
              requires2FA: true,
              pendingEmail: email,
            );
            return; 
          } else if (errorCode == AuthErrorCodes.accountLocked) {
             state = state.copyWith(
              error: AuthErrorCodes.getUserFriendlyMessage(errorCode),
              errorCode: errorCode,
              isLoading: false,
              isAccountLocked: true,
            );
            throw Exception(AuthErrorCodes.getUserFriendlyMessage(errorCode));
          }

          errorMessage = AuthErrorCodes.getUserFriendlyMessage(errorCode);
        }
      } else {
        debugPrint('🔍 Not a DioException, checking message...');
         final lowerMessage = errorMessage.toLowerCase();
        debugPrint('🔍 Lower message: $lowerMessage');

        if (lowerMessage.contains('autenticación') ||
            lowerMessage.contains('two-factor') ||
            lowerMessage.contains('2fa')) {
          debugPrint('🔐 2FA DETECTED BY MESSAGE! Setting requires2FA = true');
          state = state.copyWith(
            error: null,
            errorCode: AuthErrorCodes.twoFactorRequired,
            isLoading: false,
            requires2FA: true,
            pendingEmail: email,
          );
          debugPrint('🔐 State updated, returning without throwing exception');
          return;
        } else {
          debugPrint('⚠️ Message does not match 2FA patterns');
        }
      }

      state = state.copyWith(
        error: errorMessage,
        errorCode: errorCode,
        isLoading: false,
        isAuthenticated: false,
      );

      throw Exception(errorMessage);
    }
  }

   Future<void> login2FA(String email, String password, String code) async {
    state = state.copyWith(isLoading: true, error: null, errorCode: null);

    try {
      final authService = ref.read(authServiceProvider);
      final authResponse = await authService.login2FA(
        email: email,
        password: password,
        code: code,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
        error: null,
        errorCode: null,
        requires2FA: false,
        pendingEmail: null,
      );
    } on String catch (errorMessage) {
      state = state.copyWith(error: errorMessage, isLoading: false);
      rethrow;
    } catch (e) {
      final errorMessage = e.toString();
      state = state.copyWith(error: errorMessage, isLoading: false);
      throw Exception(errorMessage);
    }
  }

   Future<void> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.register(
        email: email,
        username: username,
        password: password,
        fullName: fullName,
      );

       await login(email, password);
    } on DioException catch (e) {
      String errorMessage = 'Error al crear la cuenta';

      if (e.response?.statusCode == 409 || e.response?.statusCode == 400) {
        if (e.response?.data != null && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        } else {
          errorMessage = 'El usuario o email ya existe';
        }
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Servidor no encontrado';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Tiempo de conexión agotado';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de red. Verifica tu conexión';
      } else if (e.response?.data != null &&
          e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }

      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
        isAuthenticated: false,
      );

      throw Exception(errorMessage);
    } catch (e) {
      final errorMessage = 'Error inesperado: ${e.toString()}';
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
        isAuthenticated: false,
      );
      throw Exception(errorMessage);
    }
  }

   Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout();
       state = const AuthState(isInitialized: true);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

   Future<void> logoutAll() async {
    state = state.copyWith(isLoading: true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.logoutAll();
       state = const AuthState(isInitialized: true);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

   Future<void> refreshUser() async {
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
     }
  }

    void clearAuthState() {
    state = const AuthState(isInitialized: true);
  }

   void setDemoMode() {
    final demoUser = UserEntity(
      id: 'demo-user-id',
      email: 'demo@test.com',
      username: 'Demo User',
      isVerified: true,
      isActive: true,
      twoFactorEnabled: false,
      createdAt: DateTime.now(),
    );

    state = AuthState(
      user: demoUser,
      isAuthenticated: true,
      isInitialized: true,
      isLoading: false,
    );
  }

 
   Future<void> sendVerificationEmail() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendVerificationEmail();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

   Future<void> verifyEmail(String code) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.verifyEmail(code: code);

      await refreshUser();

      state = state.copyWith(isLoading: false);
    } on String catch (errorMessage) {
      state = state.copyWith(error: errorMessage, isLoading: false);
      rethrow;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      throw Exception(e.toString());
    }
  }

 
   Future<void> forgotPassword(String email) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.forgotPassword(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

   Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

   Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

 
   Future<void> updateProfile({String? username, String? fullName}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final updatedUser = await authService.updateProfile(
        username: username,
        fullName: fullName,
      );

      state = state.copyWith(user: updatedUser, isLoading: false);
    } on String catch (errorMessage) {
      state = state.copyWith(error: errorMessage, isLoading: false);
      rethrow;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      throw Exception(e.toString());
    }
  }

   Future<void> deleteAccount({
    required String password,
    required String confirmation,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.deleteAccount(
        password: password,
        confirmation: confirmation,
      );

       state = const AuthState(isInitialized: true);
    } on String catch (errorMessage) {
      state = state.copyWith(error: errorMessage, isLoading: false);
      rethrow;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      throw Exception(e.toString());
    }
  }
}
