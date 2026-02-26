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
      final response = await ApiService.post(
        '/user-service/auth/login',
        {
          'userName': username,
          'password': password,
        },
      );

      if (response['success'] == true) {
        final token = response['data']['token'];
        final userData = response['data']['user'];
        
        // Save token
        ApiService.setToken(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('userId', userData['id']);
        
        _currentUser = User.fromJson(userData);
        _isLoading = false;
        notifyListeners();
        return true;
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
        if (response['success'] == true) {
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
