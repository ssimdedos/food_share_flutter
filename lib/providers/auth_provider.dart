import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oasis/models/model.dart';
import 'package:oasis/services/auth_service.dart';

enum AuthState {initial, loading, success, error, authFailed}

class AuthProvider extends ChangeNotifier {
  final AuthService _authApi = AuthService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> login({required String email, required String password}) async {
    _state = AuthState.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      final User user = await _authApi.login(email, password);
      print('반환된 User 객체: $user');
      _currentUser = user;
      _state = AuthState.success;
      return true;
    } on DioException catch (e) {
      _currentUser = null;

      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _errorMessage = e.response?.data['message'] ?? '이메일 또는 비밀번호가 올바르지 않습니다.';
        _state = AuthState.authFailed;
      } else {
        _errorMessage = e.response?.data['message'] ?? '네트워크 오류가 발생했습니다. 다시 시도해주세요.';
        _state = AuthState.error;
      }
      return false;
    } catch (e) {
      _currentUser = null;
      _errorMessage = '예상치 못한 오류가 발생했습니다: ${e.toString()}';
      _state = AuthState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> signup({required String email, required String username, required String password}) async {
    _state = AuthState.loading;
    notifyListeners();
    try {
      final res = await _authApi.signup(email: email, username: username, password: password);
      if (res) {
        _state = AuthState.success;
        return true;
      }
      _state = AuthState.error;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    _state = AuthState.loading;
    notifyListeners();
    try {
      await _authApi.logout();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }
}