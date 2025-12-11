import '../../../../core/config/dio_client.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/two_factor_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
/// Handles coordination between remote data source and local storage
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  // ===== BASIC AUTHENTICATION =====

  @override
  Future<UserEntity> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    return await remoteDataSource.register(
      email: email,
      username: username,
      password: password,
      fullName: fullName,
    );
  }

  @override
  Future<AuthResponseEntity> login({
    required String email,
    required String password,
  }) async {
    final authResponse = await remoteDataSource.login(
      email: email,
      password: password,
    );

    // Save tokens locally
    await StorageService.saveAccessToken(authResponse.accessToken);
    await StorageService.saveRefreshToken(authResponse.refreshToken);
    await StorageService.saveUserId(authResponse.user.id);

    // Set auth token in Dio client
    DioClient.setAuthToken(authResponse.accessToken);

    return authResponse;
  }

  @override
  Future<AuthResponseEntity> login2FA({
    required String email,
    required String password,
    required String code,
  }) async {
    final authResponse = await remoteDataSource.login2FA(
      email: email,
      password: password,
      code: code,
    );

    // Save tokens locally
    await StorageService.saveAccessToken(authResponse.accessToken);
    await StorageService.saveRefreshToken(authResponse.refreshToken);
    await StorageService.saveUserId(authResponse.user.id);

    // Set auth token in Dio client
    DioClient.setAuthToken(authResponse.accessToken);

    return authResponse;
  }

  @override
  Future<void> logout() async {
    final refreshToken = await StorageService.getRefreshToken();

    try {
      await remoteDataSource.logout(refreshToken);
    } finally {
      // Always clear local data, even if remote logout fails
      await clearLocalAuthData();
    }
  }

  @override
  Future<String> refreshToken() async {
    final storedRefreshToken = await StorageService.getRefreshToken();

    if (storedRefreshToken == null) {
      throw Exception('No refresh token found');
    }

    final authResponse =
        await remoteDataSource.refreshToken(storedRefreshToken);

    // Update tokens locally
    await StorageService.saveAccessToken(authResponse.accessToken);
    DioClient.setAuthToken(authResponse.accessToken);

    return authResponse.accessToken;
  }

  // ===== EMAIL VERIFICATION =====

  @override
  Future<void> resendVerificationEmail(String email) async {
    return await remoteDataSource.resendVerificationEmail(email);
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    return await remoteDataSource.verifyEmail(email: email, code: code);
  }

  // ===== PASSWORD MANAGEMENT =====

  @override
  Future<void> forgotPassword(String email) async {
    return await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    return await remoteDataSource.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  // ===== TWO-FACTOR AUTHENTICATION =====

  @override
  Future<TwoFactorEntity> setup2FA() async {
    return await remoteDataSource.setup2FA();
  }

  @override
  Future<void> enable2FA(String code) async {
    return await remoteDataSource.enable2FA(code);
  }

  @override
  Future<void> disable2FA(String code) async {
    return await remoteDataSource.disable2FA(code);
  }

  // ===== SESSION MANAGEMENT =====

  @override
  Future<List<SessionEntity>> getSessions() async {
    return await remoteDataSource.getSessions();
  }

  @override
  Future<void> revokeSession(String sessionId) async {
    return await remoteDataSource.revokeSession(sessionId);
  }

  @override
  Future<void> revokeAllOtherSessions() async {
    return await remoteDataSource.revokeAllOtherSessions();
  }

  // ===== USER MANAGEMENT =====

  @override
  Future<UserEntity> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> updateProfile({
    String? fullName,
    String? username,
  }) async {
    return await remoteDataSource.updateProfile(
      fullName: fullName,
      username: username,
    );
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      await remoteDataSource.deleteAccount(password);
    } finally {
      // Clear local data after account deletion
      await clearLocalAuthData();
    }
  }

  // ===== LOCAL STATE =====

  @override
  Future<bool> isLoggedIn() async {
    final accessToken = await StorageService.getAccessToken();
    final refreshToken = await StorageService.getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  @override
  Future<String?> getStoredUserId() async {
    return await StorageService.getUserId();
  }

  @override
  Future<void> clearLocalAuthData() async {
    await StorageService.clearAll();
    DioClient.clearAuthToken();
  }
}
