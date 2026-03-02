import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Attempting login with username: $username');

      final response = await ApiService.post(
        '/user-service/auth/login',
        {
          'username': username, // Backend expects 'username' (lowercase)
          'password': password,
        },
      );

      print('Login response: $response');

      // Backend returns 'status' instead of 'success'
      if (response['status'] == 200 && response['data'] != null) {
        print('Login successful - parsing data...');
        final data = response['data'];
        print('Data: $data');

        final token =
            data['accessToken']; // Backend returns 'accessToken', not 'token'
        final refreshToken = data['refreshToken'];
        final userData = data['user'];

        print('Token: ${token?.substring(0, 20)}...');
        print('User data: $userData');

        // Save tokens
        ApiService.setToken(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setInt('userId', userData['id']);

        print('Creating User object from JSON...');
        _currentUser = User.fromJson(userData);
        print('User created successfully: ${_currentUser?.userName}');

        _isLoading = false;
        notifyListeners();
        print('Login completed successfully');
        return true;
      } else {
        print('Login failed - success is not true');
        print('Response: $response');
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Login error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    ApiService.clearToken();
    _currentUser = null;
    notifyListeners();
  }

  // Load saved session
  Future<bool> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token != null && userId != null) {
      ApiService.setToken(token);
      try {
        final response = await ApiService.get('/user-service/users/$userId');
        if (response['status'] == 200 && response['data'] != null) {
          _currentUser = User.fromJson(response['data']);
          notifyListeners();
          return true;
        }
      } catch (e) {
        print('Load session error: $e');
      }
    }
    return false;
  }
}
