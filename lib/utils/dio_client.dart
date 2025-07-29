import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: Platform.isAndroid ? 'http://10.0.2.2:3037/api' : 'http://localhost:3037/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
  )
);
final FlutterSecureStorage storage = FlutterSecureStorage();

void setupDioClient() {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String? token;
      try {
        token = await storage.read(key: 'jwt_token');
      } on PlatformException catch (e) {
        if (e.code == 'Libsecret error') {
          print('Libsecret error: Failed to unlock the keyring. Proceeding without token for now.');
        } else {
          rethrow;
        }
      }

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        try {
          await storage.delete(key: 'jwt_token');
          print('Token deleted due to 401.');
        } on PlatformException catch (e) {
          print('Error deleting token from secure storage: ${e.message}');
        } catch (e) {
          print('Unexpected error deleting token: $e');
        }
      }
      return handler.next(error);
    },
  ));
}