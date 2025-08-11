import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oasis/models/model.dart';
import 'package:oasis/utils/dio_client.dart';

class AuthService {
  final Dio _dio = dio;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> signup({required String email, required String username, required String password}) async {
    try {
      final res = await _dio.post('/user/signup',
      data: {'email': email, 'username': username, 'password': password}
      );
      if (res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('회원가입 실패: $e');
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final res = await _dio.post('/user/login',
        data: { 'email' : email, 'password' : password}
      );
      if (res.statusCode == 200) {
        final accessToken = res.data['accessToken'];
        final refreshToken = res.data['refreshToken'];
        await _storage.write(key: 'jwt_access_token', value: accessToken);
        await _storage.write(key: 'jwt_refresh_token', value: refreshToken);
        final user = User.fromJson(res.data['user']);
        print('User.fromJson, $user');
        return user;
      } else {
        throw DioException(
          requestOptions: res.requestOptions,
          response: res,
          type: DioExceptionType.badResponse,
          error: 'Login failed with status: ${res.statusCode}',
        );
      }
    } on DioException catch (err) {
      print('로그인 실패: ${err.response?.data ?? err.message}');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: ('jwt_access_token'));
    await _storage.delete(key: ('jwt_refresh_token'));
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'jwt_access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'jwt_refresh_token');
  }
}