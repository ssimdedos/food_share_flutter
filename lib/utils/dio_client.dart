import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: Platform.isAndroid ? 'http://10.0.2.2:3037/api' : 'http://localhost:3037/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
    }
  )
);
final FlutterSecureStorage storage = FlutterSecureStorage();

void setupDioClient() {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await storage.read(key: 'jwt_access_token');

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
      return handler.next(options);
    },
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        final refreshToken = await storage.read(key: 'jwt_refresh_token');
        if (refreshToken != null) {
          try{
            final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
            final refreshRes = await refreshDio.post('/user/refresh-token',
              data: { 'refreshToken': refreshToken }
            );
            if (refreshRes.statusCode == 200) {
              final newAccessToken = refreshRes.data['accessToken'];
              await storage.write(key: 'jwt_access_token', value: newAccessToken);

              error.requestOptions.headers['Authorization'] = 'Baerer $newAccessToken';
              return handler.resolve(await dio.fetch(error.requestOptions));
            }
          } catch (e) {
            if (kDebugMode) {
              print('리프레시 토큰 갱신 실패: $e');
            }
            await storage.delete(key: 'jwt_access_token');
            await storage.delete(key: 'jwt_refresh_token');
          }
        }
        try {
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