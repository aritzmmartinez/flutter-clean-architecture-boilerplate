import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final VoidCallback? onAuthenticationFailed;

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshQueue = [];

  AuthInterceptor(this._dio, {this.onAuthenticationFailed});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains(AppConstants.authRefresh)) {
      final accessToken = await StorageService.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (err.requestOptions.path.contains(AppConstants.authRefresh)) {
      await _handleRefreshFailure();
      return handler.reject(err);
    }

    if (_isRefreshing) {
      await _waitForRefresh();

      try {
        final response = await _retry(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    _isRefreshing = true;

    try {
      await _refreshToken();

      _completeRefreshQueue();

      final response = await _retry(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      await _handleRefreshFailure();
      _errorRefreshQueue();
      return handler.reject(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await StorageService.getRefreshToken();

    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await _dio.post(
      AppConstants.authRefresh,
      data: {'refresh_token': refreshToken},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final newAccessToken = response.data['access_token'] as String;
    await StorageService.saveAccessToken(newAccessToken);

    final newRefreshToken = response.data['refresh_token'] as String;
    await StorageService.saveRefreshToken(newRefreshToken);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final accessToken = await StorageService.getAccessToken();

    requestOptions.headers['Authorization'] = 'Bearer $accessToken';

    return await _dio.fetch(requestOptions);
  }

  Future<void> _waitForRefresh() async {
    final completer = Completer<void>();
    _refreshQueue.add(completer);
    return completer.future;
  }

  void _completeRefreshQueue() {
    for (final completer in _refreshQueue) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
    _refreshQueue.clear();
  }

  void _errorRefreshQueue() {
    for (final completer in _refreshQueue) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Token refresh failed'));
      }
    }
    _refreshQueue.clear();
  }

  Future<void> _handleRefreshFailure() async {
    await StorageService.clearAll();

    onAuthenticationFailed?.call();
  }
}
