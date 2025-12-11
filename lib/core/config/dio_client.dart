import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import 'auth_interceptor.dart';

class DioClient {
  static Dio? _instance;
  static AuthInterceptor? _authInterceptor;

  static Dio get instance {
    if (_instance == null) {
      _instance = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: AppConstants.connectionTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      _authInterceptor = AuthInterceptor(_instance!);

      _instance!.interceptors.add(_authInterceptor!);

      _instance!.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }

    return _instance!;
  }

  static void setOnAuthenticationFailed(VoidCallback callback) {
    if (_authInterceptor != null) {
      _instance!.interceptors.removeWhere((i) => i is AuthInterceptor);

      _authInterceptor = AuthInterceptor(
        _instance!,
        onAuthenticationFailed: callback,
      );

      _instance!.interceptors.insert(0, _authInterceptor!);
    }
  }

  static void setAuthToken(String token) {
    instance.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken() {
    instance.options.headers.remove('Authorization');
  }
}
